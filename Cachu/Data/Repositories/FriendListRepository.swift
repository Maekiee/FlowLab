import Foundation


final class FriendListRepository {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension FriendListRepository: FriendListRepositoryProtocol {
    
    func postCreateChatRoom(userId dto: CreateChatRoomDTO) async throws -> ChatRoomResponseEntity {
        let endPoist = ApiEndpoint.postChats(userId: dto)
        do {
            let res = try await apiClient.request(endPoist, type: ChatRoomResponseDTO.self)
            return res.toEntity()
        } catch let error as NetworkError {
            print("네트워크 에러: \(error)")
            throw error
        } catch let error as DecodingError {
            print("디코딩 에러: \(error)")
            throw error
        } catch {
            print("알수 없는 에러: \(error)")
            throw error
        }
    }
    
    
}
