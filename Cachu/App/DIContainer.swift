import SwiftUI

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
    
}


// MARK: - Repository Factories
extension DIContainer {
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(network: networkService)
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
}


// MARK: - View Factories
extension DIContainer: AppViewFactory {
    @MainActor
    func makeLoginView() -> AnyView {
        return AnyView(LoginView())
    }
    
    @MainActor
    func makeSignUpView() -> AnyView {
        let store = makeSignUpStore()
        return AnyView(SignUpView(store: store))
    }
}
