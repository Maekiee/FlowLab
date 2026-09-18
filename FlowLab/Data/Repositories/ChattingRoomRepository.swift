import Foundation

final class ChattingRoomRepository {
    private let apiClient: ApiClientProtocol
    private let localDataSource: ChatLocalDataSourceProtocol

    init(apiClient: ApiClientProtocol, localDataSource: ChatLocalDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }
}

extension ChattingRoomRepository: ChattingRoomRepositoryProtocol {
    /// 로컬 DB에서 채팅 메시지 조회
    func getLocalMessages(roomId: String) async -> [ChatResponseEntity] {
        await localDataSource.getMessages(roomId: roomId)
    }

    /// 서버에서 새로운 메시지 조회 후 로컬 DB에 저장
    func fetchNewMessages(roomId: String) async throws -> [ChatResponseEntity] {
        // 1. 로컬 DB에서 가장 최근 메시지의 타임스탬프 조회
        let cursor = await localDataSource.getLastMessageTimestamp(roomId: roomId)

        // 2. 서버에서 cursor 이후의 메시지만 요청
        let endPoint = ApiEndpoint.getMessage(roomId: roomId, next: cursor)

        do {
            let res = try await apiClient.request(endPoint, type: ChatListResponseDTO.self)
            let newMessages = res.data.map { $0.toEntity() }

            // 3. 새 메시지가 있으면 로컬 DB에 저장
            if !newMessages.isEmpty {
                await localDataSource.saveMessages(newMessages)
            }

            // 4. 로컬 DB의 전체 메시지 반환
            return await localDataSource.getMessages(roomId: roomId)
        } catch let error as NetworkError {
            print("네트워크 에러:: \(error)")
            throw error
        } catch let error as DecodingError {
            print("디코딩 에러:: \(error)")
            throw error
        } catch {
            print("알수 없는 에러:: \(error)")
            throw error
        }
    }

    /// 메시지 전송 후 로컬 DB에 저장
    func postSendMessage(roomId: String, message: ChatMessageDTO) async throws -> ChatResponseEntity {
        let endPoint = ApiEndpoint.postMessage(roomId: roomId, message: message)

        do {
            let res = try await apiClient.request(endPoint, type: ChatResponseDTO.self)
            let entity = res.toEntity()

            // 전송 성공 시 로컬 DB에 저장
            await localDataSource.saveMessage(entity)

            return entity
        } catch let error as NetworkError {
            print("네트워크 에러:: \(error)")
            throw error
        } catch let error as DecodingError {
            print("디코딩 에러:: \(error)")
            throw error
        } catch {
            print("알수 없는 에러:: \(error)")
            throw error
        }
    }
}
