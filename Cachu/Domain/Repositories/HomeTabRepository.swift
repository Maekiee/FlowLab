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
    
    func getHotProperties() async throws -> EstateGeoListResponseDTO {
        let endPoint = ApiEndpoint.hotProperties
        return try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
    }
    
    func getDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO {
        let endPoint = ApiEndpoint.dailyRealEstateTopics
        return try await apiClient.request(endPoint, type: DailyRealEstateTopicsDTO.self)
    }
}
