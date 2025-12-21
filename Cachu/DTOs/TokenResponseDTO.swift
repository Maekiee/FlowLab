import Foundation

struct TokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
