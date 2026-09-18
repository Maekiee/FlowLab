import Foundation

struct ChatResponseEntity: Sendable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoEntity
    let files: [String]
}
