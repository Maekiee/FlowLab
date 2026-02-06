import Foundation
import Combine

@MainActor
@Observable
final class SignUpStore: StoreProtocol {
    // MARK: - State
    struct SignUpState {
        var email = ""
        var password = ""
        var nickname = ""
        var phoneNumber = ""
        var introduce = ""
        var isLoading = false
        var errorMessage: String?

        var isValid: Bool {
            return email.contains("@") && password.count >= 6
        }
    }

    // MARK: - Intent
    enum SignUpIntent {
        case updateEmail(String)
        case updatePassword(String)
        case updateNickname(String)
        case updatePhoneNumber(String)
        case updateIntroduce(String)
        case tapSignUpButton
    }

    // MARK: - SideEffect (UI 피드백만)
    enum SideEffect: Equatable {
        case showToast(message: String)
        case showErrorAlert(String)
    }

    // MARK: - Properties
    private(set) var state = SignUpState()
    private let repository: SignUpRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let router: AppRouter

    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    // MARK: - Initialization
    init(
        repository: SignUpRepositoryProtocol,
        tokenManager: TokenManagerProtocol,
        router: AppRouter
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
        self.router = router
    }
    
    func action(_ intent: SignUpIntent) {
        switch intent {
        case .updateEmail(let text):
            state.email = text
            state.errorMessage = nil
        case .updatePassword(let text):
            state.password = text
            state.errorMessage = nil
        case .updateNickname(let nickname):
            state.nickname = nickname
        case .updatePhoneNumber(let phoneNum):
            state.phoneNumber = phoneNum
        case .updateIntroduce(let introduce):
            state.introduce = introduce
        case .tapSignUpButton:
            requestSignUp()
        }
    }
    
    // MARK: - Private Methods
    private func requestSignUp() {
        Task {
            state.isLoading = true
            defer { state.isLoading = false }
            
            let fcmToken = await tokenManager.getFCMToken() ?? ""
            
            let userRegisterInfo = JoinRequestDTO(
                email: state.email,
                password: state.password,
                nick: state.nickname,
                phoneNum: state.phoneNumber,
                introduction: state.introduce,
                deviceToken: fcmToken
            )
            
            do {
                let response = try await repository.signUp(request: userRegisterInfo)

                try await tokenManager.saveTokens(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken
                )
                try await tokenManager.saveUserId(response.userId)

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
