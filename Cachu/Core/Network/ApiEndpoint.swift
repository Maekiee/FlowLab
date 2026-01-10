import Foundation


enum ApiEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case join(JoinRequestDTO)
    case refresh(accessToken: String, refreshToken: String)
    
    var baseURL: URL {
        return URL(string: AppConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/users/login"
        case .join: return "/users/join"
        case .refresh: return "/auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .join:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var headers: [String: String] {
        var baseHeaders = [
            "SesacKey": AppConfig.SeSACKey,
            "Content-Type": "application/json"
        ]
        
        if case .refresh(let accessToken, let refreshToken) = self {
            baseHeaders["Authorization"] = accessToken
            baseHeaders["RefreshToken"] = refreshToken
        }
        
        return baseHeaders
    }
    
    var body: Data? {
        switch self {
        case .login(let loginDTO):
            return try? JSONEncoder().encode(loginDTO)
        case .join(let joinDTO):
            return try? JSONEncoder().encode(joinDTO)
        case .refresh:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .login, .join, .refresh: return false
        }
    }
}
