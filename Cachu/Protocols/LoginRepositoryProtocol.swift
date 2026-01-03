import Foundation

protocol LoginRepositoryProtocol {
    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO
    
}
