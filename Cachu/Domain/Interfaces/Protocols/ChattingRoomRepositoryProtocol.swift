import Foundation


protocol ChattingRoomRepositoryProtocol {
    func getChatMessages(roomId: String, next: String?) async throws -> [ChatResponseEntity]
}
