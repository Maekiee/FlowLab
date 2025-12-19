import Foundation


enum APIEndpoint: EndpointProtocol {
    case login(email: String, pass: String)
    case refresh(token: String)
    case userProfile
    
    // TODO: 실제 서버 주소로 변경하세요
    var baseURL: String {
        return "http://some api end point adress is here"
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .refresh: return "/auth/refresh"
        case .userProfile: return "/users/me"
        }
    }
    
    var method: String {
        switch self {
        case .login, .refresh: return "POST"
        case .userProfile: return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let pass):
            return ["email": email, "password": pass]
        case .refresh(let token):
            return ["refreshToken": token]
        default:
            return nil
        }
    }
}
