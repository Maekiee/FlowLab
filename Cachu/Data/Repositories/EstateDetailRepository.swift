import Foundation


final class EstateDetailRepository: EstateDetailRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension EstateDetailRepository {
    func fetchEstateDetail(estateId: String) async throws -> EstateDetailEntity {
        let endPoint = ApiEndpoint.getEstateDetail(estateId: estateId)
        let data = try await apiClient.request(endPoint, type: EstateDetailResponseDTO.self)
        return data.toEntity()
    }
}
