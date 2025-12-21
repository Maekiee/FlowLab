import Foundation

protocol TokenManagerProtocol: Sendable {
    func getAccessToken() async -> String?
    func refreshTokens() async throws -> Bool // 성공 시 true 반환
}
