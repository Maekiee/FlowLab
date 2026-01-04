import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case requestFailed(description: String)
    case decodingFailed
    case unknown
    
    // MARK: - Server Specific Errors
    /// 401: 유효하지 않은 토큰 (로그인 필요)
    case unauthorized(String)
    
    /// 403: 권한 없음 (접근 불가)
    case forbidden(String)
    
    /// 419: 액세스 토큰 만료
    case tokenExpired(String)
    
    /// 420: SeSAC Key 불일치
    case invalidServerKey(String)
    
    /// 429: 과도한 호출
    case excessiveCall(String)
    
    /// 444: 잘못된 URL 경로
    case invalidPath(String)
    
    /// 500: 서버 내부 에러
    case serverError(String)
    
    /// 그 외 서버 에러 (메시지 포함)
    case commonError(statusCode: Int, message: String)
    
    var errorDescription: String {
        switch self {
        case .invalidURL: return "유효하지 않은 URL입니다."
        case .requestFailed(let desc): return "요청 실패: \(desc)"
        case .decodingFailed: return "데이터 디코딩에 실패했습니다."
        case .unknown: return "알 수 없는 에러가 발생했습니다."
        case .unauthorized(let message): return message
        case .forbidden(let message): return message
        case .tokenExpired(let message): return message
        case .invalidServerKey(let message): return message
        case .excessiveCall(let message): return message
        case .invalidPath(let message): return message
        case .serverError(let message): return message
        case .commonError(_, let message): return message
        }
    }
}
