import Foundation

protocol ChattingRoomRepositoryProtocol {
    /// 로컬 DB에서 채팅 메시지 조회
    func getLocalMessages(roomId: String) async -> [ChatResponseEntity]

    /// 서버에서 새로운 메시지 조회 후 로컬 DB에 저장하고 전체 메시지 반환
    func fetchNewMessages(roomId: String) async throws -> [ChatResponseEntity]

    /// 메시지 전송 후 로컬 DB에 저장
    func postSendMessage(roomId: String, message: ChatMessageDTO) async throws -> ChatResponseEntity
}
