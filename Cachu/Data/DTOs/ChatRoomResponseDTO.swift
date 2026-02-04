import Foundation

// MARK: - DTOs

struct ChatRoomResponseDTO: Decodable, Sendable {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoDTO]
    let lastChat: ChatResponseDTO?
}

extension ChatRoomResponseDTO: EntityConvertible {
    func toEntity() -> ChatRoomResponseEntity {
        ChatRoomResponseEntity(
            roomId: room_id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            participants: participants.map { $0.toEntity() },
            lastChat: lastChat?.toEntity()
        )
    }
}

