import Foundation
import Combine

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
    }
    
    enum Intent {
        case onAppear
    }
    
    enum SideEffect {
        
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getMessages(roomId: self.roomId, next: self.next)
        }
    }
}


extension ChattingRoomStore {
    private func getMessages(roomId: String, next: String?) {
        Task {
            do {
                let res = try await repository.getChatMessages(roomId: roomId, next: next)
                print("대화방 채팅 내용 리스트 :: \(res)")
            } catch let error as NetworkError {
                print(error.errorDescription)
            }
        }
    }
}
