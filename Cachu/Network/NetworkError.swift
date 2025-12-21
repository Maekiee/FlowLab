import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(description: String)
    case decodingFailed
    case serverError(statusCode: Int)
    case unknown
}
