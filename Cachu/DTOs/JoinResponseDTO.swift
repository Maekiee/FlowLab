import Foundation

struct JoinResponseDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"  // 변환 필요한 것만 값 지정
        case email                // 나머지는 이름만 나열
        case nick
        case accessToken
        case refreshToken
    }
}
