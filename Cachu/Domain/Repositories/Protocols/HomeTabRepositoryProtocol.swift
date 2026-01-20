import Foundation


protocol HomeTabRepositoryProtocol {
    func fetchBanners() async throws -> Banners
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO
}
