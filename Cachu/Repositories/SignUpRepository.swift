import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    /// 이메일 회원가입
    func signUp(request: JoinRequestDTO) async throws -> JoinResponseDTO {
        let endpoint = APIEndpoint.join(request)
        return try await network.request(endpoint, type: JoinResponseDTO.self)
    }
}
