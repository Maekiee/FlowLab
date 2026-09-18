import Foundation

protocol ChattingTabRepositoryProtocol {
    func fetchChatRoomList() async throws -> [ChatRoomEntity]
}
