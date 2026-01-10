import SwiftUI

final class DIContainer: Sendable {
    let tokenManager: TokenManagerProtocol
    let apiClient: ApiClientProtocol
    let keychainManager: KeychainServiceProtocol

    init() {
        self.keychainManager = KeychainService()

        let authApiClient = ApiClient(interceptor: nil)

        let tokenManager = TokenManager(
            keychain: keychainManager,
            apiClient: authApiClient
        )
        self.tokenManager = tokenManager

        // 일반 API용 ApiClient (Interceptor 포함)
        let interceptor = Interceptor(tokenManager: tokenManager)
        self.apiClient = ApiClient(interceptor: interceptor)
    }
}


// MARK: - Repository
extension DIContainer {
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(apiClient: apiClient)
    }
    
    func makeLoginRepository() -> LoginRepositoryProtocol {
        return LoginRepository(apiClient: apiClient)
    }
}


// MARK: - Store
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
            tokenManager: self.tokenManager,
        )
    }
}


// MARK: - View
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
