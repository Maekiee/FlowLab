import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func signUp(request: JoinRequestDTO) async throws -> JoinResponseDTO {
        // Endpoint 생성
        let endpoint = APIEndpoint.join(request)
        
        // ApiClient의 request 메서드 호출 (제네릭으로 응답 타입 명시)
        return try await network.request(endpoint, type: JoinResponseDTO.self)
    }
}
