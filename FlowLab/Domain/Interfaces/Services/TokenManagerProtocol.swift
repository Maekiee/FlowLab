import Foundation

protocol TokenManagerProtocol: Sendable {
    func getAccessToken() async -> String?
    func getRefreshToken() async -> String?
    func saveTokens(accessToken: String, refreshToken: String) async throws
    func clearTokens() async throws
    func refreshTokens() async throws -> Bool // 성공 시 true 반환
    func tryAutoLogin() async -> Bool // 자동 로그인 시도, 성공 시 true 반환

    // MARK: - FCM Token
    func getFCMToken() async -> String?

    // MARK: - User ID
    func getUserId() async -> String?
    func saveUserId(_ userId: String) async throws
}
