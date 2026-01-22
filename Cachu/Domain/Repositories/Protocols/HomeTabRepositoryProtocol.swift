import Foundation


protocol HomeTabRepositoryProtocol {
    func fetchHomeTabTopItems() async throws -> HomeTabTopItems
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO
    func fetchBannerMain() async throws -> BannersDTO
}
