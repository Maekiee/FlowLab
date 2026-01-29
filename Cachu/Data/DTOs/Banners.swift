import Foundation


struct BannersDTO: Decodable, Hashable, Sendable {
    let data: [BannerDTO]
}



struct BannerDTO: Decodable, Hashable, Sendable {
    let name: String
    let imageUrl: String
    let payload: PayloadDTO
}


struct PayloadDTO: Decodable, Hashable, Sendable {
    let type: String
    let value: String
    
}
