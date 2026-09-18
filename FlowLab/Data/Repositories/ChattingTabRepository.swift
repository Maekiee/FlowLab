import Foundation


final class ChattingTabRepository {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension ChattingTabRepository: ChattingTabRepositoryProtocol {
    func fetchChatRoomList() async throws -> [ChatRoomEntity] {
        let endPoint = ApiEndpoint.getChats
        do {
            let res = try await apiClient.request(endPoint, type: ChatRoomListDTO.self)
            return res.data.map { $0.toEntity() }
        } catch let error as NetworkError {
            print("네트워크 에러:", error)
            throw error as NetworkError
        } catch let error as DecodingError {
            print("디코디 에러:", error)
            throw error
        } catch {
            print("알 수 없는 에러:", error)
            throw error
        }
    }
    
    
}
