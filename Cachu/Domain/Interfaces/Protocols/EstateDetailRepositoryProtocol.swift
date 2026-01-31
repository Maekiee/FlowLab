import Foundation

protocol EstateDetailRepositoryProtocol {
    func fetchEstateDetail(estateId: String) async throws -> EstateDetailEntity
    func postOrderReservation(orderInfo: OrderInfoDTO) async throws -> OrderResponseDTO
}
