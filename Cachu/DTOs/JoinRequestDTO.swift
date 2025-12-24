import Foundation

struct JoinRequestDTO: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String
    let introduction: String
    let deviceToken: String
}
