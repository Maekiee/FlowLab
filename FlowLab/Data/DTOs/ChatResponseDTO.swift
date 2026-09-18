import Foundation

struct ChatListResponseDTO: Decodable, Sendable {
    let data: [ChatResponseDTO]
}

extension ChatListResponseDTO: EntityConvertible {
    func toEntity() -> ChatListResponseEntity {
        return ChatListResponseEntity(data: data.map { $0.toEntity() })
    }
}

struct ChatResponseDTO: Decodable, Sendable {
    let chat_id: String
    let room_id: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoDTO
    let files: [String]
}

extension ChatResponseDTO: EntityConvertible {
    func toEntity() -> ChatResponseEntity {
        ChatResponseEntity(
            chatId: chat_id,
            roomId: room_id,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sender: sender.toEntity(),
            files: files
        )
    }
}
