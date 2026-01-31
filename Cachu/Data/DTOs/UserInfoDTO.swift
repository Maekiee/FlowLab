import Foundation


struct UserInfoDTO: Decodable, Sendable {
    let user_id: String
    let nick: String
    let introduction: String
    let profileImage: String
}


extension UserInfoDTO {
    func toEntity() -> UserInfoEntity {
        UserInfoEntity(
            userId: user_id,
            nick: nick,
            introduction: introduction,
            profileImage: profileImage
        )
    }
}
