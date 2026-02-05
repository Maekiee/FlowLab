import Foundation

final class ChattingRoomRepository {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension ChattingRoomRepository: ChattingRoomRepositoryProtocol {
    func getChatMessages(roomId: String, next: String?) async throws -> [ChatResponseEntity] {
        let endPoint = ApiEndpoint.getMessage(roomId: roomId, next: next)
        do {
            let res = try await apiClient.request(endPoint, type: ChatListResponseDTO.self)
            return res.data.map { $0.toEntity() }
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
