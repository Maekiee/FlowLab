import Foundation
import Combine

final class ChattingRoomStore: StoreProtocol {
    let roomId: String
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    init(roomId: String) {
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
