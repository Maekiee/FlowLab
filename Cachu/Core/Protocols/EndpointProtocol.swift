import Foundation



protocol Endpoint: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var requiresAuth: Bool { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var headers: [String: String] {
        return [
            "SesacKey": AppConfig.SeSACKey,
            "Content-Type":"application/json",
        ]
    }
    
    var body: Data? {
        return nil
    }
    
    // 기본값: 인증 필요 (실수 방지)
    var requiresAuth: Bool {
        return true
    }
    
    var queryItems: [URLQueryItem]? { return nil }
}
