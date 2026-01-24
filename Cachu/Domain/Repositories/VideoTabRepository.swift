import Foundation


final class VideoTabRepository: VideoTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension VideoTabRepository {
    
}
