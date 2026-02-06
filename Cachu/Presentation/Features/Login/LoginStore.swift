import Foundation
import Combine

@MainActor
@Observable
final class LoginStore: StoreProtocol {
    // MARK: - State
    struct LoginState {
        var email = ""
        var password = ""
        var isLoading = false
        var errorMessage: String?
    }

    // MARK: - Intent
    enum LoginIntent {
        case inputEmail(String)
        case inputPassword(String)
        case tapLogin
        case dismissError
    }

    // MARK: - SideEffect (UI 피드백만)
    enum SideEffect: Equatable {
        case showErrorAlert(String)
    }

    // MARK: - Properties
    private(set) var state = LoginState()
    private let repository: LoginRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let router: AppRouter

    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    init(
        repository: LoginRepositoryProtocol,
        tokenManager: TokenManagerProtocol,
        router: AppRouter
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
        self.router = router
    }
    
    func action(_ intent: LoginIntent) {
        switch intent {
        case .inputEmail(let text):
            state.email = text
        case .inputPassword(let password):
            state.password = password
        case .tapLogin:
            emailLogin()
        case .dismissError:
            state.errorMessage = nil
        }
    }
    
    // MARK: - Private Methods
    private func emailLogin() {
      

        Task {
            state.isLoading = true
            defer { state.isLoading = false }
            
            let fcmToken = await tokenManager.getFCMToken() ?? ""
            
            let loginForm = LoginRequestDTO(
                email: state.email,
                password: state.password,
                deviceToken: fcmToken
            )

            do {
                let response = try await repository.login(request: loginForm)

                try await tokenManager.saveTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                try await tokenManager.saveUserId(response.user_id)

                // Router를 통해 직접 네비게이션
                router.switchToMain()

            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
}
