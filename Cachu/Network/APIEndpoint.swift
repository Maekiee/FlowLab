import Foundation


enum APIEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case getProfile
    case join(JoinRequestDTO)
    
    var baseURL: URL {
        return URL(string: AppConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/users/login"
        case .getProfile: return "/profile"
        case . join: return "/users/join"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .join: return .post
        case .getProfile: return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let loginDTO):
            return try? JSONEncoder().encode(loginDTO)
        case .getProfile:
            return nil
        case .join(let joinDTO):
            return try? JSONEncoder().encode(joinDTO)
        }
    }
    
    // ✅ 작성하신 의도대로 인증 여부 제어
    var requiresAuth: Bool {
        switch self {
        case .login, .join(_): return false // 로그인엔 토큰 필요 없음
        case .getProfile: return true
        }
    }
}
