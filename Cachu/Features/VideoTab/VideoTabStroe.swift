import Foundation
import Combine

@MainActor
@Observable
final class VideoTabStroe: StoreProtocol {
    struct State {
        
    }
    
    enum Intent {
        
    }
    
    enum SideEffect {
        
    }
    
    private(set) var state = State()
    private let repository: VideoTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: VideoTabRepositoryProtocol,
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

extension VideoTabStroe {
    
}
