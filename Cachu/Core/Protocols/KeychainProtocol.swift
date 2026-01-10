import Foundation

protocol KeychainServiceProtocol: Sendable {
    func save(data: Data, service: String, account: String) async throws
    func read(service: String, account: String) -> Data?
    func delete(service: String, account: String) async throws
    
    // 편의 메서드 (String 지원)
    func save(token: String, service: String, account: String) async throws
    func readToken(service: String, account: String) async -> String?
}
