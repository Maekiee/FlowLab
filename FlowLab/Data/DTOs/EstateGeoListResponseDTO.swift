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

extension EstateSummaryResponseDTO {
    func toEntity() -> EstateEntity {
        return EstateEntity(
            id: estate_id,
            category: category,
            title: title,
            introduction: introduction,
            thumbnails: thumbnails,
            deposit: deposit,
            monthly_rent: monthly_rent,
            built_year: built_year,
            area: area,
            floors: floors,
            geolocation: geolocation.toEntity(),
            distance: distance,
            likeCount: like_count,
            isSafeEstate: is_safe_estate,
            isRecommended: is_recommended,
            createdAt: created_at,
            updatedAt: updated_at
        )
    }
}

