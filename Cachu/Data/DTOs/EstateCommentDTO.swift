import Foundation


// MARK: - Comment
struct EstateCommentDTO: Decodable, Sendable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: UserInfoDTO
    let replies: [EstateReplyDTO]
}


// MARK: - Reply
struct EstateReplyDTO: Decodable, Sendable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: UserInfoDTO
}


extension EstateCommentDTO {
    func toEntity() -> EstateCommentEntity {
        EstateCommentEntity(
            id: comment_id,
            content: content,
            createdAt: createdAt,
            creator: creator.toEntity(),
            replies: replies.map { $0.toEntity() }
        )
    }
}

extension EstateReplyDTO {
    func toEntity() -> EstateReplyEntity {
        EstateReplyEntity(
            id: comment_id,
            content: content,
            createdAt: createdAt,
            creator: creator.toEntity()
        )
    }
}
