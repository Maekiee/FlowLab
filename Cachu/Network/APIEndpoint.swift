import Foundation


enum APIEndpoint: Endpoint {
    case login
    case getProfile
    
    var baseURL: URL {
        return URL(string: AppConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/login"
        case .getProfile: return "/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .getProfile: return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .login:
            // 딕셔너리([String: Any]) 대신 Encodable -> Data 변환
            return nil
        case .getProfile:
            return nil
        }
    }
    
    // ✅ 작성하신 의도대로 인증 여부 제어
    var requiresAuth: Bool {
        switch self {
        case .login: return false // 로그인엔 토큰 필요 없음
        case .getProfile: return true
        }
    }
}
