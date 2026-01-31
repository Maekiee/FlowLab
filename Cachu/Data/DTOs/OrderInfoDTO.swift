import Foundation


// MARK: - Request
struct OrderInfoDTO: Codable {
    let estate_id: String
    let total_price: Int
}


// MARK: - Response
struct OrderResponseDTO: Decodable, Sendable {
    let order_id: String
    let order_code: String
    let total_price: Int
    let createdAt: String
    let updatedAt: String
}
