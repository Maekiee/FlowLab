import Foundation

struct ChatRoomResponseDTO {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoDTO]
    let lastChat: ChatResponseDTO
    
}

struct ChatResponseDTO {
    let chat_id: String
    let room_id: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoDTO
    let files: [String]
}

// entitiy
struct ChatRoomResponseEntity {
    let room_id: String
    let createdAt: String
    let updatedAt: String
    let participants: [UserInfoEntity]
    let lastChat: ChatResponseDTO
}


struct ChatResponseEntity {
    let chat_id: String
    let room_id: String
    let content: String
    let createdAt: String
    let updatedAt: String
    let sender: UserInfoEntity
    let files: [String]
}
