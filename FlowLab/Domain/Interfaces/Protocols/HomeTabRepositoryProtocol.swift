import Foundation


protocol HomeTabRepositoryProtocol {
    func fetchHomeTabTopItems() async throws -> [EstateEntity]
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO
    func fetchBannerMain() async throws -> BannersDTO
}
