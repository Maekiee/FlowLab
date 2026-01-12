import Foundation
import Combine

@MainActor
@Observable
final class ProfileTabStore: StoreProtocol {
    struct State {
        
    }
    
    enum Intent {
        case tapLogout
    }
    
    enum SideEffect {
        
    }
    
    private(set) var state = State()
    
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init() { }
    
    func action(_ intent: Intent) {
        switch intent {
        case .tapLogout:
            logout()
        }
    }
    
    private func logout() {
        
    }
    
}
