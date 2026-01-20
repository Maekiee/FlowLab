import Foundation



final class HomeTabRepository: HomeTabRepositoryProtocol {
    
    
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension HomeTabRepository {
    func fetchBanners() async throws -> Banners {
        let endPoint = ApiEndpoint.homeBanner
        let item = try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
        return Banners(from: item)
    }
    
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO {
        let endPoint = ApiEndpoint.hotProperties
        return try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
    }
    
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO {
        let endPoint = ApiEndpoint.dailyRealEstateTopics
        return try await apiClient.request(endPoint, type: DailyRealEstateTopicsDTO.self)
    }
}
