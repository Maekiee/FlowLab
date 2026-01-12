import Foundation

struct EmptyResponseDTO: Decodable, Sendable {
    // 내용 없음
    init() {}
}

final class ProfileTabRepository: ProfileTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func logout() async throws -> EmptyResponseDTO {
        try await apiClient.request(ApiEndpoint.logout, type: EmptyResponseDTO.self)
    }
}
