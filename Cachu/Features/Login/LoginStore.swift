import Foundation
import Combine

@MainActor
@Observable
final class LoginStore: StoreProtocol {
    struct LoginState {
        var email = ""
        var password = ""
        var errorMessage: String?
    }

    enum LoginIntent {
        case inputEmail(String)
        case inputPassword(String)
        case tapLogin
        case dismissError
    }

    enum SideEffect: Equatable {
        case navigateToMain
        case showErrorAlert(String)
    }
    
    private(set) var state = LoginState()
    private let repository: LoginRepositoryProtocol
    private let keychainManager: KeychainManagerProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: LoginRepositoryProtocol,
        keychainManager: KeychainManagerProtocol
    ) {
        self.repository = repository
        self.keychainManager = keychainManager
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
    
    private func emailLogin() {
        let loginForm = LoginRequestDTO(
            email: state.email,
            password: state.password,
            deviceToken: ""
        )
        
        Task {
            do {
                let response = try await repository.login(request: loginForm)
                
                try await keychainManager.save(
                    token: response.accessToken,
                    service: AppConfig.bundleID,
                    account: "accessToken"
                )
                
                try await keychainManager.save(
                    token: response.refreshToken,
                    service: AppConfig.bundleID,
                    account: "refreshToken"
                )
                
                effectSubject.send(.navigateToMain)
                
                // 키체인 에 엑세스 리프레시 토큰 저장
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
                print("실패1 \(error.errorDescription)")
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
                print("실패2 \(error.localizedDescription)")
            }
        }
    }
}
