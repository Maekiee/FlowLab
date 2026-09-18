import Foundation

protocol ChatLocalDataSourceProtocol: Sendable {
    /// 특정 채팅방의 모든 메시지 조회 (createdAt 기준 정렬)
    func getMessages(roomId: String) async -> [ChatResponseEntity]

    /// 특정 채팅방의 가장 최근 메시지 타임스탬프 조회
    func getLastMessageTimestamp(roomId: String) async -> String?

    /// 여러 메시지 저장
    func saveMessages(_ messages: [ChatResponseEntity]) async

    /// 단일 메시지 저장
    func saveMessage(_ message: ChatResponseEntity) async

    /// 특정 채팅방의 모든 메시지 삭제
    func deleteMessages(roomId: String) async
}
