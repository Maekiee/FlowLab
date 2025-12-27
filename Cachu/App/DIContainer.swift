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
    
    // MARK: - Repository Factories
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(network: networkService)
    }
    
    // MARK: - ViewModel Factories
    @MainActor
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(repository: makeSignUpRepository())
    }
}

extension DIContainer: AppViewFactory {
    
    @MainActor
    func makeLoginView() -> AnyView {
        return AnyView(LoginView())
    }
    
    @MainActor
    func makeSignUpView() -> AnyView {
        let viewModel = makeSignUpViewModel()
        return AnyView(SignUpView())
    }
    
}
