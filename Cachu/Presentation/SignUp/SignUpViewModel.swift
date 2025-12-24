// ViewModels/SignUpViewModel.swift
import Foundation
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    private let repository: SignUpRepositoryProtocol
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(repository: SignUpRepositoryProtocol) {
        self.repository = repository
    }
    
    func requestSignUp() {
        // 입력받은 값으로 DTO 생성
        let requestDTO = JoinRequestDTO(
            email: "dowon5@sesac.com",
            password: "dowontest123!",
            nick: "쿠키5",
            phoneNum: "01039438239",
            introduction: "안녕하세요",
            deviceToken: ""
        )
        
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let response = try await repository.signUp(request: requestDTO)
                print("✅ 회원가입 성공: \(response)")
                // 성공 후 화면 전환 처리 등
            } catch {
                print("❌ 회원가입 실패: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
