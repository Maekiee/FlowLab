import Foundation
import Combine

@MainActor
@Observable
final class VideoDetailStore: StoreProtocol {
    
    struct State {
        
    }
    
    enum Intent {
        
    }
    
    enum SideEffect {
        
    }
    
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init() {
        
    }
    
    func action(_ intent: Intent) {
        
    }
}
