import Foundation


final class VideoTabRepository {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension VideoTabRepository: VideoTabRepositoryProtocol {
    func fetchVideoList() async throws -> VideoListDTO {
        let endPoint = ApiEndpoint.getVideos(next: nil, limit: "5")
        return try await apiClient.request(endPoint, type: VideoListDTO.self)
    }
}
