import Foundation

final class LoginRepository: LoginRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        let endpoint = APIEndpoint.login(request)
        print("로그인 api 호출", request)
        return LoginResponseDTO(user_id: "", email: "", profileImage: "", accessToken: "", refreshToken: "")
    }
}
