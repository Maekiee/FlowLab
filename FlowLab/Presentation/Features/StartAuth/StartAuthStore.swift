import Foundation
import Combine

@MainActor
@Observable
final class StartAuthStore: StoreProtocol {
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    struct State {
        
    }
    
    enum Intent {
        
    }
    
    enum SideEffect: Equatable {
        
    }
    
    func action(_ intent: Intent) {
        
    }
}
