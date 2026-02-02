import Foundation

// MARK: - Receipt Order Response
struct ReceiptOrderDTO: Decodable, Sendable {
    let payment_id: String
    let order_item: ReceiptOrderItemDTO
    let createdAt: String
    let updatedAt: String
}

// MARK: - Order Item
struct ReceiptOrderItemDTO: Decodable, Sendable {
    let order_id: String
    let order_code: String
    let estate: ReceiptEstateDTO
    let paidAt: String
    let createdAt: String
    let updatedAt: String
}

// MARK: - Estate
struct ReceiptEstateDTO: Decodable, Sendable {
    let id: String
    let category: String
    let title: String
    let introduction: String
    let thumbnails: [String]
    let deposit: Double
    let monthly_rent: Double
    let built_year: String
    let area: Double
    let floors: Double
    let geolocation: GeolocationDTO
    let created_at: String
    let updated_at: String
}
