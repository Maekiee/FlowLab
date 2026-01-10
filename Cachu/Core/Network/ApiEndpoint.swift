import Foundation


enum ApiEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case join(JoinRequestDTO)
    case refresh(accessToken: String, refreshToken: String)
    case logout
    
    var baseURL: URL {
        return URL(string: AppConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/users/login"
        case .join: return "/users/join"
        case .refresh: return "/auth/refresh"
        case .logout: return "/users/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .join, .logout:
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
        case .refresh, .logout:
            return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .login, .join, .refresh:
            return false
        case .logout:
            return true
        }
    }
}
