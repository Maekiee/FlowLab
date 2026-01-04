import Foundation

final class ApiClient: NetworkServiceProtocol, Sendable {
    
    private let session: URLSession
    private let interceptor: InterceptorProtocol?
    
    init(session: URLSession = .shared, interceptor: InterceptorProtocol? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        guard let url = createURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        return try await performRequest(request, endpoint: endpoint, type: type)
    }
    
    private func performRequest<T: Decodable & Sendable>
    (_ request: URLRequest,
     endpoint: Endpoint,
     type: T.Type,
     retryCount: Int = 0) async throws -> T {
        
        let finalRequest = await interceptor?.adapt(request, for: endpoint) ?? request
        
        do {
            let (data, response) = try await session.data(for: finalRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                return try JSONDecoder().decode(T.self, from: data)
            }
            
            if let interceptor = interceptor, retryCount < 2 {
                let retryResult = await interceptor.retry(finalRequest, dueTo: .success(httpResponse))
                
                switch retryResult {
                case .retry:
                    return try await performRequest(request, endpoint: endpoint, type: type, retryCount: retryCount + 1)
                case .doNotRetryWithError(let error):
                    throw error
                case .doNotRetry:
                    break
                }
            }
            
            let errorMessage: String
            if let errorDTO = try? JSONDecoder().decode(NetworkErrorResponseDTO.self, from: data) {
                errorMessage = errorDTO.message
            } else {
                errorMessage = getDefaultMessage(for: httpResponse.statusCode)
            }
            
            switch httpResponse.statusCode {
            case 401: throw NetworkError.unauthorized(errorMessage)
            case 403: throw NetworkError.forbidden(errorMessage)
            case 419: throw NetworkError.tokenExpired(errorMessage)
            case 420: throw NetworkError.invalidServerKey(errorMessage)
            case 429: throw NetworkError.excessiveCall(errorMessage)
            case 444: throw NetworkError.invalidPath(errorMessage)
            case 500: throw NetworkError.serverError(errorMessage)
            default:  throw NetworkError.commonError(statusCode: httpResponse.statusCode, message: errorMessage)
            }
            
        } catch {
            if let interceptor = interceptor, retryCount < 2 {
                let retryResult = await interceptor.retry(finalRequest, dueTo: .failure(error))
                
                if case .retry = retryResult {
                    return try await performRequest(request, endpoint: endpoint, type: type, retryCount: retryCount + 1)
                }
            }
            throw error
        }
    }
    
    private func createURL(from endpoint: Endpoint) -> URL? {
        guard var components = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        components.path += endpoint.path
        components.queryItems = endpoint.queryItems
        return components.url
    }
    
    private func getDefaultMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 401: return "인증할 수 없는 액세스 토큰입니다."
        case 403: return "Forbidden"
        case 419: return "액세스 토큰이 만료되었습니다."
        case 429: return "과호출입니다."
        case 444: return "비정상적인 URL 요청입니다."
        case 500: return "Server Error"
        default: return "네트워크 오류가 발생했습니다."
        }
    }
}
