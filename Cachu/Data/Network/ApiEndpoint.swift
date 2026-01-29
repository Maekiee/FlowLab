import Foundation


enum ApiEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case join(JoinRequestDTO)
    case validEmail(EmailDTO)
    case refresh(accessToken: String, refreshToken: String)
    case logout
    case homeBanner
    case hotProperties
    case dailyRealEstateTopics
    case bannerMain
    case getVideos(next: String?, limit: String)
    case getVideoStream(videoId: String)
    
    var baseURL: URL {
        return URL(string: AppConfig.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login: return "/users/login"
        case .validEmail: return "/users/validation/email"
        case .join: return "/users/join"
        case .refresh: return "/auth/refresh"
        case .logout: return "/users/logout"
        case .homeBanner: return "/estates/today-estates"
        case .hotProperties: return "/estates/hot-estates"
        case .dailyRealEstateTopics: return "/estates/today-topic"
        case .bannerMain: return "/banners/main"
        case .getVideos: return "/videos"
        case .getVideoStream(let id): return "/videos/\(id)/stream"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .join, .validEmail, .logout:
            return .post
        case
                .refresh,
                .homeBanner,
                .hotProperties,
                .dailyRealEstateTopics,
                .bannerMain,
                .getVideos,
                .getVideoStream:
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
        case .validEmail(let emailDTO):
            return try? JSONEncoder().encode(emailDTO)
        case
                .refresh,
                .logout,
                .homeBanner,
                .hotProperties,
                .dailyRealEstateTopics,
                .bannerMain,
                .getVideos,
                .getVideoStream:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getVideos(let next, let limit):
            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "limit", value: limit)
            ]
            
            if let next = next, !next.isEmpty {
                queryItems.append(URLQueryItem(name: "next", value: next))
            }
            
            return queryItems
        default: return nil
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .login, .join, .refresh, .validEmail:
            return false
        case .logout, .homeBanner, .hotProperties, .dailyRealEstateTopics, .bannerMain, .getVideos,
                .getVideoStream:
            return true
        }
    }
}
