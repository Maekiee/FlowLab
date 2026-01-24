import Foundation


final class VideoTabRepository: VideoTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension VideoTabRepository {
    func fetchVideoList() async throws -> VideoListDTO {
        let endPoint = ApiEndpoint.getVideos
        return try await apiClient.request(endPoint, type: VideoListDTO.self)
    }
}
