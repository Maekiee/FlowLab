import Foundation


// MARK: - Estate Detail
struct EstateDetailEntity: Identifiable, Sendable {
    let id: String
    let category: String
    let title: String
    let introduction: String
    let reservationPrice: Int
    let description: String
    let thumbnails: [String]
    let deposit: Int
    let monthlyRent: Int
    let builtYear: String
    let maintenanceFee: Int
    let area: Int
    let parkingCount: Int
    let floors: Int
    let options: [String]
    let geolocation: GeolocationEntity
    let creator: UserInfoEntity
    let likeCount: Int
    let isLiked: Bool
    let isReserved: Bool
    let isSafeEstate: Bool
    let isRecommended: Bool
    let comments: [EstateCommentEntity]
    let createdAt: String
    let updatedAt: String
}
