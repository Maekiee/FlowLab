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
    
    func postOrderReservation(orderInfo: OrderInfoDTO) async throws -> OrderResponseDTO {
        let endPoint = ApiEndpoint.order(orderInfo: orderInfo)
        let data = try await apiClient.request(endPoint, type: OrderResponseDTO.self)
        print(" ⭕️⭕️⭕️⭕️ 주문 번호 생성 성공  \(data)")
        return data
    }
}
