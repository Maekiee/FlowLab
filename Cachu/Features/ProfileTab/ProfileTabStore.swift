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
    private let repository: ProfileTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
//    private let router: AppRouter
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: ProfileTabRepositoryProtocol,
        tokenManager: TokenManagerProtocol,
//        router: AppRouter
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
//        self.router = router
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .tapLogout:
            logout()
        }
    }
    
    private func logout() {
        Task {
            do {
                let res = try await repository.logout()
                print(res)
                print("로그 아웃 성공")
            } catch let error as NetworkError {
                print("에러", error.errorDescription)
            }
            
            try? await tokenManager.clearTokens()
            
            await AuthEventManager.shared.send(.sessionExpired)
        }
    }
    
}
