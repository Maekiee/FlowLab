import Foundation


protocol HomeTabRepositoryProtocol {
    func getBanner() async throws -> EstateGeoListResponseDTO
}
