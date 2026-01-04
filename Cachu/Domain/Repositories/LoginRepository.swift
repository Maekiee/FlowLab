import Foundation

final class LoginRepository: LoginRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        let endpoint = APIEndpoint.login(request)
        return try await network.request(endpoint, type: LoginResponseDTO.self)
    }
}
