import Foundation


protocol ChattingRoomRepositoryProtocol {
    func getChatMessages(roomId: String, next: String?) async throws -> [ChatResponseEntity]
    func postSendMessage(roomId: String, message: ChatMessageDTO) async throws -> ChatResponseEntity
}
