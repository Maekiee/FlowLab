import Foundation
import CoreLocation

struct EstateEntity: Identifiable, Sendable {
    let id: String
    let category: String
    let title: String
    let introduction: String
    let thumbnails: [String]
    let deposit: Int
    let monthly_rent: Int
    let built_year: String
    let area: Double
    let floors: Int
    let geolocation: GeolocationEntity
    let distance: Double?
    let likeCount: Int
    let isSafeEstate: Bool
    let isRecommended: Bool
    let createdAt: String
    let updatedAt: String
}

