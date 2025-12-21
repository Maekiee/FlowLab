//
//  DIContainer.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//


import Foundation

actor DIContainer: DIContainerProtocol {
    public static let shared = DIContainer()
    
    private init() {}
    
    private var factories: [String: @Sendable () -> Any] = [:]
    private var cache: [String: Any] = [:] // Singleton 인스턴스 캐싱용 (옵션)
    
    public func register<T>(_ type: T.Type, factory: @escaping @Sendable () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }
    
    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        // Factory 조회
        guard let factory = factories[key] else {
            fatalError("Dependency '\(T.self)' not registered!")
        }
        
        // 인스턴스 생성 및 반환
        guard let instance = factory() as? T else {
            fatalError("Type mismatch for dependency '\(T.self)'")
        }
        
        return instance
    }
}


//final class DIContainer: Sendable {
//    
//    // Core (Singleton-like lifecycle managed by Container)
//    private let tokenManager: TokenManager
//    private let networkRouter: NetworkRouterProtocol
//    
//    init() {
//        self.tokenManager = TokenManager.shared
//        
//        let interceptor = AuthInterceptor(tokenManager: self.tokenManager)
//        self.networkRouter = NetworkRouter(interceptor: interceptor)
//    }
//    
//    // MARK: - Repository Factories
//    func makeUserRepository() -> LoginRepositoryProtocol {
//        return LoginRepository(router: networkRouter)
//    }
//    
//    
//    // MARK: - ViewModel Factories
//    @MainActor
//    func makeLoginViewModel() -> LoginViewModel {
//        return LoginViewModel(repository: makeUserRepository())
//    }
//}
