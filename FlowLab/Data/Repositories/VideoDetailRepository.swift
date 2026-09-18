import Foundation


final class VideoDetailRepository {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension VideoDetailRepository: VideoDetailRepositoryProtocol {
    func fetchVideo(videoId: String) async throws -> VideoStreamDTO {
        let endPoint = ApiEndpoint.getVideoStream(videoId: videoId)
        return try await apiClient.request(endPoint, type: VideoStreamDTO.self)
    }
    
}
