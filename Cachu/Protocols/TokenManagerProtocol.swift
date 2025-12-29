import Foundation

protocol TokenManagerProtocol: Sendable {
    func getAccessToken() async -> String?
    func getRefreshToken() -> String?
    func saveTokens(accessToken: String, refreshToken: String) throws
    func clearTokens() throws
    func refreshTokens() async throws -> Bool // 성공 시 true 반환
}
