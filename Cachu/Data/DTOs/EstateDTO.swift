import Foundation


// MARK: - Estate Detail Response
struct EstateDetailResponseDTO: Decodable, Sendable {
    let estate_id: String
    let category: String
    let title: String
    let introduction: String
    let reservation_price: Int
    let description: String
    let thumbnails: [String]
    let deposit: Double
    let monthly_rent: Double
    let built_year: String
    let maintenance_fee: Double
    let area: Double
    let parking_count: Double
    let floors: Double
    let options: EstateOptionsDTO
    let geolocation: GeolocationDTO
    let creator: UserInfoDTO
    let like_count: Int
    let is_liked: Bool
    let is_reserved: Bool
    let is_safe_estate: Bool
    let is_recommended: Bool
    let comments: [EstateCommentDTO]
    let created_at: String
    let updated_at: String
}


// MARK: - Options
struct EstateOptionsDTO: Decodable, Sendable {
    let option1: String?
    let option2: String?
    let option3: String?
    let option4: String?
    let option5: String?
    let option6: String?
    let option7: String?
    let option8: String?
    let option9: String?

    var allOptions: [String] {
        [option1, option2, option3, option4, option5,
         option6, option7, option8, option9].compactMap { $0 }
    }
}


extension EstateDetailResponseDTO {
    func toEntity() -> EstateDetailEntity {
        EstateDetailEntity(
            id: estate_id,
            category: category,
            title: title,
            introduction: introduction,
            reservationPrice: reservation_price,
            description: description,
            thumbnails: thumbnails,
            deposit: deposit,
            monthlyRent: monthly_rent,
            builtYear: built_year,
            maintenanceFee: maintenance_fee,
            area: area,
            parkingCount: parking_count,
            floors: floors,
            options: options.allOptions,
            geolocation: geolocation.toEntity(),
            creator: creator.toEntity(),
            likeCount: like_count,
            isLiked: is_liked,
            isReserved: is_reserved,
            isSafeEstate: is_safe_estate,
            isRecommended: is_recommended,
            comments: comments.map { $0.toEntity() },
            createdAt: created_at,
            updatedAt: updated_at
        )
    }
}
