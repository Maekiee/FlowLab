import Foundation

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
