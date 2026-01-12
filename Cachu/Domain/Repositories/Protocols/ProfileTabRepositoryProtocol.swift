import Foundation


protocol ProfileTabRepositoryProtocol {
    func logout() async throws -> EmptyResponseDTO
}
