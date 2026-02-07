import Foundation
import SocketIO
import Combine

protocol SocketIOManagerProtocol {
    var messageReceived: AnyPublisher<ChatResponseEntity, Never> { get }
    func connect(roomId: String, accessToken: String)
    func disconnect()
    var isConnected: Bool { get }
}

final class SocketIOManager: SocketIOManagerProtocol {
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private var currentRoomId: String?

    private let messageSubject = PassthroughSubject<ChatResponseEntity, Never>()
    var messageReceived: AnyPublisher<ChatResponseEntity, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    var isConnected: Bool {
        socket?.status == .connected
    }

    func connect(roomId: String, accessToken: String) {
        // 기존 연결이 있으면 해제
        disconnect()

        currentRoomId = roomId

        // Socket.IO 연결 URL 구성 (namespace: /chat-{room_id})
        guard let url = URL(string: AppConfig.baseURLWeb) else {
            print("❌ 소켓 URL 생성 실패")
            return
        }

        let namespace = "/chats-\(roomId)"

        manager = SocketManager(
            socketURL: url,
            config: [
                .log(true),
                .compress,
                .extraHeaders([
                    AppConfig.SeSACKeyName: AppConfig.SeSACKey,
                    AppConfig.AuthorizationName: accessToken
                ])
            ]
        )

        socket = manager?.socket(forNamespace: namespace)

        setupEventHandlers()

        socket?.connect()
        print("🔌 소켓 연결 시도: \(url.absoluteString)\(namespace)")
    }

    func disconnect() {
        socket?.disconnect()
        socket = nil
        manager = nil
        currentRoomId = nil
        print("🔌 소켓 연결 해제")
    }

    private func setupEventHandlers() {
        socket?.on(clientEvent: .connect) { [weak self] _, _ in
            print("✅ 소켓 연결 성공 - roomId: \(self?.currentRoomId ?? "unknown")")
        }

        socket?.on(clientEvent: .disconnect) { [weak self] _, _ in
            print("🔴 소켓 연결 끊김 - roomId: \(self?.currentRoomId ?? "unknown")")
        }

        socket?.on(clientEvent: .error) { data, _ in
            print("❌ 소켓 에러: \(data)")
        }

        // 채팅 메시지 수신 이벤트
        socket?.on("chat") { [weak self] data, _ in
            self?.handleChatMessage(data)
        }
    }

    private func handleChatMessage(_ data: [Any]) {
        guard let first = data.first else {
            print("❌ 소켓 메시지 데이터 없음")
            return
        }

        do {
            let jsonData: Data
            if let dict = first as? [String: Any] {
                jsonData = try JSONSerialization.data(withJSONObject: dict)
            } else if let string = first as? String, let data = string.data(using: .utf8) {
                jsonData = data
            } else {
                print("❌ 소켓 메시지 파싱 불가")
                return
            }

            let dto = try JSONDecoder().decode(ChatResponseDTO.self, from: jsonData)
            let entity = dto.toEntity()

            print("📩 소켓 메시지 수신: \(entity.content)")
            messageSubject.send(entity)
        } catch {
            print("❌ 소켓 메시지 디코딩 에러: \(error)")
        }
    }

    deinit {
        disconnect()
    }
}
