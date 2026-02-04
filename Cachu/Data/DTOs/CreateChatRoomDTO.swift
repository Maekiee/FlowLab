import Foundation

struct CreateChatRoomDTO: Encodable {
    let opponent_id: String
}

extension CreateChatRoomDTO: EntityConvertible {
    func toEntity() -> CreateChatRoomEntity {
        return CreateChatRoomEntity(opponentId: opponent_id)
    }
}

struct CreateChatRoomEntity {
    let opponentId: String
}
