import Foundation
import RealmSwift

final class ChatLocalDataSource: ChatLocalDataSourceProtocol, @unchecked Sendable {
    private let realm: Realm

    init() throws {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // 마이그레이션 로직 (필요시 추가)
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        self.realm = try Realm()
    }

    func getMessages(roomId: String) async -> [ChatResponseEntity] {
        let objects = realm.objects(ChatMessageObject.self)
            .filter("roomId == %@", roomId)
            .sorted(byKeyPath: "createdAt", ascending: true)

        return objects.map { $0.toEntity() }
    }

    func getLastMessageTimestamp(roomId: String) async -> String? {
        let lastMessage = realm.objects(ChatMessageObject.self)
            .filter("roomId == %@", roomId)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .first

        return lastMessage?.createdAt
    }

    func saveMessages(_ messages: [ChatResponseEntity]) async {
        do {
            try realm.write {
                for message in messages {
                    let object = ChatMessageObject(from: message)
                    realm.add(object, update: .modified)
                }
            }
        } catch {
            print("Realm 저장 실패: \(error)")
        }
    }

    func saveMessage(_ message: ChatResponseEntity) async {
        do {
            try realm.write {
                let object = ChatMessageObject(from: message)
                realm.add(object, update: .modified)
            }
        } catch {
            print("Realm 저장 실패: \(error)")
        }
    }

    func deleteMessages(roomId: String) async {
        do {
            let objects = realm.objects(ChatMessageObject.self)
                .filter("roomId == %@", roomId)

            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print("Realm 삭제 실패: \(error)")
        }
    }
}
