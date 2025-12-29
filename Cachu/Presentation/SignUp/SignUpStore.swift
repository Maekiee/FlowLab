import Foundation
import Combine


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

enum SignUpIntent {
    case updateEmail(String)
    case updatePassword(String)
    case updateNickname(String)
    case updatePhoneNumber(String)
    case updateIntroduce(String)
    case tapSignUpButton
}

enum SignUpSideEffect: Equatable {
    case navigateToLogin
    case showToast(message: String)
}


@MainActor
@Observable
final class SignUpStore {
    private(set) var state = SignUpState()
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let effectSubject = PassthroughSubject<SignUpSideEffect, Never>()
    
    var effect: AnyPublisher<SignUpSideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    private let repository: SignUpRepositoryProtocol
    
    init(repository: SignUpRepositoryProtocol) {
        self.repository = repository
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
    
    private func requestSignUp() {
        let userResterInfo = JoinRequestDTO(
            email: state.email,
            password: state.password,
            nick: state.nickname,
            phoneNum: state.phoneNumber,
            introduction: state.introduce,
            deviceToken: "")
        
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let response = try await repository.signUp(request: userResterInfo)
                print("✅ 회원가입 성공: \(response)")
                // 성공 후 화면 전환 처리 등
            } catch {
                print("❌ 회원가입 실패: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
