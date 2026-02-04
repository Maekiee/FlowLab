import Foundation
import Combine

@MainActor @Observable
final class FriendListStore: StoreProtocol {
    private let repository: FriendListRepositoryProtocol
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(repository: FriendListRepositoryProtocol) {
        self.repository = repository
    }
    
    struct State {
        var isLoading = false
    }
    
    enum Intent {
        case createRoom(String)
    }
    
    enum SideEffect {
        
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .createRoom(let userId):
            createChatRoom(userId: userId)
        }
    }
}

extension FriendListStore {
    private func createChatRoom(userId: String) {
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false }
            
            do {
                let userIdDTO = CreateChatRoomDTO(opponent_id: userId)
                let res = try await repository.postCreateChatRoom(userId: userIdDTO)
                
                print("채팅방 조회 및 생성 성공 :: \(res)")
            } catch let error as NetworkError {
                print(error)
            }
        }
    }
}
