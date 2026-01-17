import Foundation

struct DailyRealEstateTopicsDTO: Decodable, Sendable {
    let data: [DailyRealEstateDTO]
}


struct DailyRealEstateDTO: Decodable, Sendable {
    let title: String
    let content: String
    let date: String
    let link: String
}
