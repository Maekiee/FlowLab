import Foundation

struct ChatRoomListDTO: Decodable, Sendable {
    let data: [ChatRoomDTO]
}

struct ChatRoomDTO: Decodable, Sendable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoDTO]
    let lastChat: ChatDTO
}

struct ChatDTO: Decodable, Sendable {
    let chat_id: String
    let room_id: String
    let content: String
    let createAt: String
    let updateAt: String
    let sender: UserInfoDTO
    let files: [String]
}

// MARK: - Mapper
extension ChatRoomListDTO: EntityConvertible {
    func toEntity() -> ChatRoomListEntity {
        return ChatRoomListEntity(chatList: data.map { $0.toEntity() })
    }
}

extension ChatRoomDTO: EntityConvertible {
    func toEntity() -> ChatRoomEntity {
        return ChatRoomEntity(
            room_id: room_id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            participants: participants.map { $0.toEntity() },
            lastChat: lastChat.toEntity()
        )
    }
}

extension ChatDTO: EntityConvertible {
    func toEntity() -> ChatEntity {
        return ChatEntity(
            chat_id: chat_id,
            room_id: room_id,
            content: content,
            createAt: createAt,
            updateAt: updateAt,
            sender: sender.toEntity(),
            files: files
        )
    }
}
