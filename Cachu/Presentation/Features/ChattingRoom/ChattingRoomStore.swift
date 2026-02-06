import Foundation
import Combine


@MainActor @Observable
final class ChattingRoomStore: StoreProtocol {
    private let repository: ChattingRoomRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let roomId: String
    private var currentUserId: String = ""
    private var nextCursor: String?

    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    init(
        repository: ChattingRoomRepositoryProtocol,
        tokenManager: TokenManagerProtocol,
        roomId: String
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
        self.roomId = roomId
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
}


extension ChattingRoomStore {
    private func getMessages() {
        Task {
            do {
                state.isLoading = true
                currentUserId = await tokenManager.getUserId() ?? ""
                print("📱 현재 사용자 ID: \(currentUserId.isEmpty ? "없음 (빈 문자열)" : currentUserId)")
                let chatList = try await repository.getChatMessages(roomId: roomId, next: nextCursor)
                state.chatList = chatList
                state.isLoading = false
            } catch let error as NetworkError {
                state.isLoading = false
                print(error.errorDescription)
            }
        }
    }

    private func sendMessage() {
        guard !state.chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        Task {
            do {
                let message = ChatMessageDTO(content: state.chatText, files: nil)
                let res = try await repository.postSendMessage(roomId: roomId, message: message)
                state.chatList.append(res)
                state.chatText = ""
            } catch let error as NetworkError {
                print(error.errorDescription)
            }
        }
    }
}
