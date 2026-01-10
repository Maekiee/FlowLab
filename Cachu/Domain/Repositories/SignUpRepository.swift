import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    /// 이메일 회원가입
    func signUp(request: JoinRequestDTO) async throws -> JoinResponseDTO {
        let endpoint = APIEndpoint.join(request)
        return try await apiClient.request(endpoint, type: JoinResponseDTO.self)
    }
}
