import Foundation
import Combine


@MainActor @Observable
final class ChattingRoomStore: StoreProtocol {
    private let repository: ChattingRoomRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let socketManager: SocketIOManagerProtocol
    private let localDataSource: ChatLocalDataSourceProtocol
    private let roomId: String
    private var currentUserId: String = ""
    private var cancellables = Set<AnyCancellable>()

    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    init(
        repository: ChattingRoomRepositoryProtocol,
        tokenManager: TokenManagerProtocol,
        socketManager: SocketIOManagerProtocol,
        localDataSource: ChatLocalDataSourceProtocol,
        roomId: String
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
        self.socketManager = socketManager
        self.localDataSource = localDataSource
        self.roomId = roomId

        subscribeToSocketMessages()
    }

    func isFromMe(_ message: ChatResponseEntity) -> Bool {
        let result = message.sender.userId == currentUserId
        print("🔍 isFromMe 체크 - sender.userId: \(message.sender.userId), currentUserId: \(currentUserId), result: \(result)")
        return result
    }

    struct State {
        var isLoading = false
        var chatText = ""
        var chatList:[ChatResponseEntity] = []
    }
    
    enum Intent {
        case onAppear
        case inputText(String)
        case sendChat
    }
    
    enum SideEffect {
        case showError(String)
    }

    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getMessages()
        case .sendChat:
            sendMessage()
        case .inputText(let text):
            state.chatText = text
        }
    }

    func onDisappear() {
        disconnectSocket()
    }
}


// MARK: - Socket
extension ChattingRoomStore {
    private func subscribeToSocketMessages() {
        socketManager.messageReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                Task { @MainActor in
                    await self.handleSocketMessage(message)
                }
            }
            .store(in: &cancellables)
    }

    private func handleSocketMessage(_ message: ChatResponseEntity) async {
        // 중복 메시지 체크
        guard !state.chatList.contains(where: { $0.chatId == message.chatId }) else {
            print("⚠️ 중복 메시지 무시: \(message.chatId)")
            return
        }

        // 로컬 DB에 저장
        await localDataSource.saveMessage(message)

        // UI 업데이트
        state.chatList.append(message)
        print("📩 소켓 메시지 추가: \(message.content)")
    }

    private func connectSocket() async {
        guard let accessToken = await tokenManager.getAccessToken() else {
            print("❌ 소켓 연결 실패: 액세스 토큰 없음")
            return
        }

        socketManager.connect(roomId: roomId, accessToken: accessToken)
    }

    private func disconnectSocket() {
        socketManager.disconnect()
        cancellables.removeAll()
    }
}


// MARK: - Messages
extension ChattingRoomStore {
    private func getMessages() {
        Task {
            // 1. 현재 사용자 ID 조회
            currentUserId = await tokenManager.getUserId() ?? ""
            print("📱 현재 사용자 ID: \(currentUserId.isEmpty ? "없음 (빈 문자열)" : currentUserId)")

            // 2. 로컬 DB에서 채팅 내역 먼저 로드 (즉시 UI에 표시)
            let localMessages = await repository.getLocalMessages(roomId: roomId)
            if !localMessages.isEmpty {
                state.chatList = localMessages
                print("💾 로컬 DB에서 \(localMessages.count)개 메시지 로드")
            }

            // 3. 서버에서 새로운 메시지 조회 후 UI 갱신
            state.isLoading = true
            do {
                let allMessages = try await repository.fetchNewMessages(roomId: roomId)
                state.chatList = allMessages
                print("🌐 서버에서 새 메시지 조회 완료, 총 \(allMessages.count)개")
            } catch let error as NetworkError {
                print("네트워크 에러: \(error.errorDescription)")
                effectSubject.send(.showError(error.errorDescription))
            } catch {
                print("알 수 없는 에러: \(error)")
            }
            state.isLoading = false

            // 4. 데이터 로드 완료 후 소켓 연결
            await connectSocket()
        }
    }

    private func sendMessage() {
        guard !state.chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let messageText = state.chatText
        state.chatText = "" // 즉시 입력창 초기화

        Task {
            do {
                let message = ChatMessageDTO(content: messageText, files: nil)
                let res = try await repository.postSendMessage(roomId: roomId, message: message)

                // 중복 체크 (소켓으로 이미 수신된 경우 무시)
                guard !state.chatList.contains(where: { $0.chatId == res.chatId }) else {
                    print("⚠️ API 응답 메시지 중복 무시 (소켓으로 이미 수신됨): \(res.chatId)")
                    return
                }

                state.chatList.append(res)
                print("✅ 메시지 전송 성공 및 로컬 DB 저장 완료")
            } catch let error as NetworkError {
                // 전송 실패 시 입력창에 텍스트 복원 및 에러 표시
                state.chatText = messageText
                print("❌ 메시지 전송 실패: \(error.errorDescription)")
                effectSubject.send(.showError(error.errorDescription))
            } catch {
                state.chatText = messageText
                print("❌ 알 수 없는 에러: \(error)")
            }
        }
    }
}
