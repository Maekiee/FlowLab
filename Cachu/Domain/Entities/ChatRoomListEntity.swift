import Foundation

struct ChatRoomListEntity: Sendable {
    let chatList: [ChatRoomEntity]
}


struct ChatRoomEntity: Sendable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoEntity]
    let lastChat: ChatEntity?
}


struct ChatEntity: Sendable {
    let chat_id: String
    let room_id: String
    let content: String
    let createAt: String
    let updateAt: String
    let sender: UserInfoEntity
    let files: [String]
}
