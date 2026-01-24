import Foundation

protocol VideoTabRepositoryProtocol {
    func fetchVideoList() async throws -> VideoListDTO
}
