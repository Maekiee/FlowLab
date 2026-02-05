import Foundation
import Combine

final class ChattingRoomStore: StoreProtocol {
    private let repository: ChattingRoomRepositoryProtocol
    let roomId: String
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    init(repository: ChattingRoomRepositoryProtocol, roomId: String) {
        self.repository = repository
        self.roomId = roomId
    }

    struct State {

    }
    
    enum Intent {
        
    }
    
    enum SideEffect {
        
    }
    
    func action(_ intent: Intent) {
        
    }
}
