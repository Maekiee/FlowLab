import Foundation

//final class DIContainer: DIContainerProtocol, Sendable {
//    public static let shared = DIContainer()
//    
//    private init() {}
//    
//    private var factories: [String: @Sendable () -> Any] = [:]
//    private let lock = NSLock() // Thread-Safety를 위한 Lock
//    
//    public func register<T>(_ type: T.Type, factory: @escaping @Sendable () -> T) {
//        lock.lock()
//        defer { lock.unlock() }
//        
//        let key = String(describing: type)
//        factories[key] = factory
//    }
//    
//    public func resolve<T>(_ type: T.Type) -> T {
//        lock.lock()
//        defer { lock.unlock() }
//        
//        let key = String(describing: type)
//        
//        guard let factory = factories[key] else {
//            fatalError("Dependency '\(T.self)' not registered!")
//        }
//        
//        guard let instance = factory() as? T else {
//            fatalError("Type mismatch for dependency '\(T.self)'")
//        }
//        
//        return instance
//    }
//}


final class DIContainer: Sendable {
    let tokenManager: TokenManagerProtocol
    let networkService: NetworkServiceProtocol
    
    init() {
        let keychainManager = KeychainManager()
        let tokenManager = TokenManager(keychain: keychainManager)
        self.tokenManager = tokenManager
        let interceptor = Interceptor(tokenManager: tokenManager)
        self.networkService = ApiClient(interceptor: interceptor)
    }
    
//    func makeLoginRepository() -> LoginRepositoryProtocol {
//        return LoginRepository(network: networkService)
//    }
    
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(network: networkService)
    }
    
    // MARK: - ViewModel Factories
//    @MainActor
//    func makeLoginViewModel() -> LoginViewModel {
//        // 뷰모델 생성 시 리포지토리 주입
//        return LoginViewModel(repository: makeLoginRepository())
//    }
//    
    @MainActor
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(repository: makeSignUpRepository())
    }
}
