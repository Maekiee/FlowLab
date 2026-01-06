import SwiftUI

final class DIContainer: Sendable {
    let tokenManager: TokenManagerProtocol
    let networkService: NetworkServiceProtocol
    let keychainManager: KeychainManagerProtocol
    
    init() {
        self.keychainManager = KeychainManager()
        let tokenManager = TokenManager(keychain: keychainManager)
        self.tokenManager = tokenManager
        let interceptor = Interceptor(tokenManager: tokenManager)
        self.networkService = ApiClient(interceptor: interceptor)
    }
    
}


// MARK: - Repository Factories
extension DIContainer {
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(network: networkService)
    }
    
    func makeLoginRepository() -> LoginRepositoryProtocol {
        return LoginRepository(network: networkService)
    }
}


// MARK: - Store Factories
extension DIContainer {
    @MainActor
    func makeSignUpStore() -> SignUpStore {
        return SignUpStore(
            repository: makeSignUpRepository(),
            tokenManager: self.tokenManager,
        )
    }
    
    @MainActor
    func makeLoginStore() -> LoginStore {
        return LoginStore(
            repository: makeLoginRepository(),
            keychainManager: keychainManager
        )
    }
}


// MARK: - View Factories
extension DIContainer: AppViewFactory {
    @MainActor
    func makeStartAuthView() -> AnyView {
        return AnyView(StartAuthView())
    }
    
    @MainActor
    func makeLoginView() -> AnyView {
        let store = makeLoginStore()
        return AnyView(LoginView(store: store))
    }
    
    @MainActor
    func makeSignUpView() -> AnyView {
        let store = makeSignUpStore()
        return AnyView(SignUpView(store: store))
    }
    
    @MainActor
    func makeMainView() -> AnyView {
        return AnyView(MainView())
    }
}
