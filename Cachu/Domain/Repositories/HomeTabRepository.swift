import Foundation



final class HomeTabRepository: HomeTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension HomeTabRepository {
    func getBanner() async throws -> EstateGeoListResponseDTO {
        let endPoint = ApiEndpoint.homeBanner
        return try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
    }
}
