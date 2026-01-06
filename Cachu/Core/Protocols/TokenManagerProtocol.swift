import Foundation

protocol TokenManagerProtocol: Sendable {
    func getAccessToken() async -> String?
    func getRefreshToken() async -> String?
    func saveTokens(accessToken: String, refreshToken: String) async throws
    func clearTokens() async throws
    func refreshTokens() async throws -> Bool // 성공 시 true 반환
}
