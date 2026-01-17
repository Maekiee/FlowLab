import Foundation


protocol HomeTabRepositoryProtocol {
    func getBanner() async throws -> EstateGeoListResponseDTO
    func getHotProperties() async throws -> EstateGeoListResponseDTO
    func getDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO
}
