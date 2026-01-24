import SwiftUI

@MainActor
@Observable
final class DIContainer {
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


// MARK: - Router Factory
extension DIContainer {
    @MainActor
    func makeAppRouter() -> AppRouter {
        return AppRouter(container: self, tokenManager: tokenManager)
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
    
    func makeProfileTabRepository() -> ProfileTabRepositoryProtocol {
        return ProfileTabRepository(apiClient: apiClient)
    }
    
    func makeHomeTabRepository() -> HomeTabRepositoryProtocol {
        return HomeTabRepository(apiClient: apiClient)
    }
    
    func makeVideoTabRepository() -> VideoTabRepositoryProtocol {
        return VideoTabRepository(apiClient: apiClient)
    }
}


// MARK: - Store
extension DIContainer {
    @MainActor
    func makeSignUpStore(router: AppRouter) -> SignUpStore {
        return SignUpStore(
            repository: makeSignUpRepository(),
            tokenManager: tokenManager,
            router: router
        )
    }

    @MainActor
    func makeLoginStore(router: AppRouter) -> LoginStore {
        return LoginStore(
            repository: makeLoginRepository(),
            tokenManager: tokenManager,
            router: router
        )
    }
    
    @MainActor
    func makeProfileTabStore() -> ProfileTabStore {
        return ProfileTabStore(
            repository: makeProfileTabRepository(),
            tokenManager: tokenManager
//            router: router
        )
    }
    
    
    @MainActor
    func makeHomeTabStore() -> HomeTabStore {
        return HomeTabStore(
            repository: makeHomeTabRepository(),
            tokenManager: tokenManager
        )
    }
    
    @MainActor
    func makeVideoTabStore() -> VideoTabStroe {
        return VideoTabStroe(
            repository: makeVideoTabRepository(),
            tokenManager: tokenManager,
        )
    }
}


// MARK: - Auth View Factory
extension DIContainer {
    @MainActor
    func makeStartAuthView() -> StartAuthView {
        return StartAuthView()
    }

    @MainActor
    func makeLoginView(router: AppRouter) -> LoginView {
        let store = makeLoginStore(router: router)
        return LoginView(store: store)
    }

    @MainActor
    func makeSignUpView(router: AppRouter) -> SignUpView {
        let store = makeSignUpStore(router: router)
        return SignUpView(store: store)
    }
    
    @MainActor
    func makeProfileTabView() -> ProfileTabView {
        let store = makeProfileTabStore()
        return ProfileTabView(store: store)
    }
    
    @MainActor
    func makeHomeTabView() -> HomeTabView {
        let store = makeHomeTabStore()
        return HomeTabView(store: store)
    }
    
    func makeVideoTabView() -> VideoTabView {
        let store = makeVideoTabStore()
        return VideoTabView(store: store)
    }
}


// MARK: - Main View Factory
extension DIContainer {
    @MainActor
    func makeMainTabView() -> MainTabView {
        return MainTabView()
    }
}
