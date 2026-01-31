import Foundation

struct GeolocationDTO: Decodable, Sendable {
    let longitude: Double
    let latitude: Double
}

extension GeolocationDTO {
    func toEntity() -> GeolocationEntity {
        return GeolocationEntity(
            longitude: longitude,
            latitude: latitude
        )
    }
}
