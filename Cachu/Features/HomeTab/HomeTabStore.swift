import Foundation
import Combine

@MainActor
@Observable
final class HomeTabStore: StoreProtocol {
    struct State {
        
    }
    
    enum Intent {
        
    }
    
    enum SideEffect {
        
    }
    
    private(set) var state = State()
    private let repository: HomeTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: HomeTabRepositoryProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func action(_ intent: Intent) {
        switch intent {
            
        }
    }
}
