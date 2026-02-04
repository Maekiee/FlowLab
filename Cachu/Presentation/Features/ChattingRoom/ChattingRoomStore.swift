import Foundation
import Combine

final class ChattingRoomStore: StoreProtocol {
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    
    init() {
        
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
