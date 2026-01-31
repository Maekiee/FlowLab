import Foundation

struct EstateCommentEntity: Identifiable, Sendable {
    let id: String
    let content: String
    let createdAt: String
    let creator: UserInfoEntity
    let replies: [EstateReplyEntity]
}


struct EstateReplyEntity: Identifiable, Sendable {
    let id: String
    let content: String
    let createdAt: String
    let creator: UserInfoEntity
}
