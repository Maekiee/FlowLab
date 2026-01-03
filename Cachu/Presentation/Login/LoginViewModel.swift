import Foundation
import Combine

struct LoginState {
    var email = ""
    var password = ""
}

enum LoginIntent {
    case inputEmail(String)
    case inputPassword(String)
    case tapLogin
}

@MainActor
final class LoginStore {
    private(set) var state = LoginState()
    
    
    private let repository: LoginRepositoryProtocol
    
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    func action(_ intent: LoginIntent) {
        switch intent {
        case .inputEmail(let text):
            state.email = text
        case .inputPassword(let password):
            state.password = password
        case .tapLogin:
            emailLogin()
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
            } catch {
                print("로그인 실패: \(error)")
            }
        }
    }
}
