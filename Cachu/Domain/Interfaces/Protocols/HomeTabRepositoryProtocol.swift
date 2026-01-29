import Foundation


protocol HomeTabRepositoryProtocol {
    func fetchHomeTabTopItems() async throws -> HomeTabTopViewData
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO
    func fetchBannerMain() async throws -> BannersDTO
}
