import Foundation
import RealmSwift

final class ChatMessageObject: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var roomId: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var updatedAt: String
    @Persisted var senderId: String
    @Persisted var senderNick: String
    @Persisted var senderIntroduction: String
    @Persisted var senderProfileImage: String?
    @Persisted var files: List<String>

    convenience init(from entity: ChatResponseEntity) {
        self.init()
        self.chatId = entity.chatId
        self.roomId = entity.roomId
        self.content = entity.content
        self.createdAt = entity.createdAt
        self.updatedAt = entity.updatedAt
        self.senderId = entity.sender.userId
        self.senderNick = entity.sender.nick
        self.senderIntroduction = entity.sender.introduction
        self.senderProfileImage = entity.sender.profileImage
        self.files.append(objectsIn: entity.files)
    }

    func toEntity() -> ChatResponseEntity {
        ChatResponseEntity(
            chatId: chatId,
            roomId: roomId,
            content: content,
            createdAt: createdAt,
            updatedAt: updatedAt,
            sender: UserInfoEntity(
                userId: senderId,
                nick: senderNick,
                introduction: senderIntroduction,
                profileImage: senderProfileImage
            ),
            files: Array(files)
        )
    }
}
