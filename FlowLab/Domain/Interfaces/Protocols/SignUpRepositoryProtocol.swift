import Foundation

protocol SignUpRepositoryProtocol {
    func signUp(request: JoinRequestDTO) async throws -> JoinResponseDTO
}
