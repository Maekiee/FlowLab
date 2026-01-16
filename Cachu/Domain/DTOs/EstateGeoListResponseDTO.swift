import Foundation

struct EstateGeoListResponseDTO: Decodable, Sendable {
    let data: [EstateSummaryResponseDTO]
}

struct EstateSummaryResponseDTO: Decodable, Sendable {
    let estate_id: String
    let category: String
    let title: String
    let introduction: String
    let thumbnails: [String]
    let deposit: Int
    let monthly_rent: Int
    let built_year: String
    let area: Double
    let floors: Int
    let geolocation: GeolocationDTO
    let distance: Double?
    let like_count: Int
    let is_safe_estate: Bool
    let is_recommended: Bool
    let created_at: String
    let updated_at: String
}

struct GeolocationDTO: Decodable, Sendable {
    let longitude: Double
    let latitude: Double
}
