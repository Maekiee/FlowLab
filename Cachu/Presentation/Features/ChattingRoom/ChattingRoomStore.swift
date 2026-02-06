import Foundation
import Combine


@MainActor @Observable
final class ChattingRoomStore: StoreProtocol {
    private let repository: ChattingRoomRepositoryProtocol
    private let roomId: String
    private let next: String?
    
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    init(
        repository: ChattingRoomRepositoryProtocol,
        roomId: String,
        next: String?
    ) {
        self.repository = repository
        self.roomId = roomId
        self.next = next
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
                let chatList = try await repository.getChatMessages(roomId: self.roomId, next: self.next)
                print("대화방 채팅 내용 리스트 :: \(chatList)")
                state.chatList = chatList
            } catch let error as NetworkError {
                print(error.errorDescription)
            }
        }
    }
    
    private func sendMessage() {
        Task {
            do {
                let message = ChatMessageDTO(content: state.chatText, files: nil)
                
                let res = try await repository.postSendMessage(roomId: self.roomId, message: message)
                print("채팅 보내기 성공:\(res)")
            } catch let error as NetworkError {
                print(error.errorDescription)
            }
        }
    }
}
