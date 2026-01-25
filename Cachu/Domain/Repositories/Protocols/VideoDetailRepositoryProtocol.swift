import Foundation


protocol VideoDetailRepositoryProtocol {
    func fetchVideo(videoId: String) async throws -> VideoStreamDTO
}
