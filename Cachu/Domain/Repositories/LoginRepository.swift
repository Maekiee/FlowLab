import Foundation

final class LoginRepository: LoginRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        let endpoint = APIEndpoint.login(request)
        return try await apiClient.request(endpoint, type: LoginResponseDTO.self)
    }
}
