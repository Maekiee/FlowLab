import Foundation


struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
    let deviceToken: String
}
