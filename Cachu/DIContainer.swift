//
//  DIContainer.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//


import Foundation

final class DIContainer: Sendable {
    
    // Core (Singleton-like lifecycle managed by Container)
    private let tokenManager: TokenManager
    private let networkRouter: NetworkRouterProtocol
    
    init() {
        self.tokenManager = TokenManager.shared
        
        let interceptor = AuthInterceptor(tokenManager: self.tokenManager)
        self.networkRouter = NetworkRouter(interceptor: interceptor)
    }
    
    // MARK: - Repository Factories
    func makeUserRepository() -> LoginRepositoryProtocol {
        return LoginRepository(router: networkRouter)
    }
    
    
    // MARK: - ViewModel Factories
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(repository: makeUserRepository())
    }
}
