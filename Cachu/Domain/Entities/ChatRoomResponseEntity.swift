import Foundation


struct ChatRoomResponseEntity: Sendable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoEntity]
    let lastChat: ChatResponseEntity
}
