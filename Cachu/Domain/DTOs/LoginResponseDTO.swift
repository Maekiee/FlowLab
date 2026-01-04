import Foundation

struct LoginResponseDTO: Decodable, Sendable {
    let user_id: String
    let email: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
