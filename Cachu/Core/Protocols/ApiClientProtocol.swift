import Foundation

protocol ApiClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T
}
