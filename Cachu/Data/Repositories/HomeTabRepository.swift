import Foundation



final class HomeTabRepository: HomeTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension HomeTabRepository {
    func fetchHomeTabTopItems() async throws -> [EstateEntity] {
        let endPoint = ApiEndpoint.homeBanner
        let item = try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
        return item.data.map { $0.toEntity() }
    }
    
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO {
        let endPoint = ApiEndpoint.hotProperties
        return try await apiClient.request(endPoint, type: EstateGeoListResponseDTO.self)
    }
    
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO {
        let endPoint = ApiEndpoint.dailyRealEstateTopics
        return try await apiClient.request(endPoint, type: DailyRealEstateTopicsDTO.self)
    }
    
    func fetchBannerMain() async throws -> BannersDTO {
        let endPoint = ApiEndpoint.bannerMain
        return try await apiClient.request(endPoint, type: BannersDTO.self)
    }
}
