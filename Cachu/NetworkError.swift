import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case unauthorized
    case decodingError
    case unknown
}
