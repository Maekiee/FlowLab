import Foundation

protocol FriendListRepositoryProtocol {
    func postCreateChatRoom(userId dto: CreateChatRoomDTO) async throws -> ChatRoomResponseEntity
}
