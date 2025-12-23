import Foundation

protocol LoginRepositoryProtocol {
    func login() async throws -> LoginDTO
}
