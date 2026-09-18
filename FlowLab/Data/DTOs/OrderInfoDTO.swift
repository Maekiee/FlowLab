import Foundation

// MARK: - Request
struct OrderInfoDTO: Codable {
    let estate_id: String
    let total_price: Int
}

extension OrderInfoDTO: EntityConvertible {
    func toEntity() -> OrderInfoEntity {
        return OrderInfoEntity(
            estatId: estate_id,
            totalPrice: total_price
        )
    }
}


// MARK: - Response (w)
struct OrderResponseDTO: Decodable, Sendable {
    let order_id: String
    let order_code: String
    let total_price: Int
    let createdAt: String
    let updatedAt: String
}

extension OrderResponseDTO:EntityConvertible {
    func toEntity() -> ReservationInfoEntity {
        return ReservationInfoEntity(
            orderId: order_id,
            orderCode: order_code,
            totalPrice: total_price,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
