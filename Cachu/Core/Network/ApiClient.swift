import Foundation

// MARK: - Network Client Implementation
final class ApiClient: NetworkServiceProtocol, Sendable {
    
    private let session: URLSession
    private let interceptor: InterceptorProtocol?
    
    init(session: URLSession = .shared, interceptor: InterceptorProtocol? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
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
    
    // 재귀 호출을 위한 내부 메서드
    private func performRequest<T: Decodable>(_ request: URLRequest, endpoint: Endpoint, type: T.Type, retryCount: Int = 0) async throws -> T {
        
        // 1. Adapt (요청 가로채기)
        let finalRequest = await interceptor?.adapt(request, for: endpoint) ?? request
        
        do {
            // 2. URLSession Data Task
            let (data, response) = try await session.data(for: finalRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            // 3. Retry Check (서버 응답 기반)
            if !(200...299).contains(httpResponse.statusCode) {
                // Interceptor에게 재시도 여부 확인
                if let interceptor = interceptor {
                    guard retryCount < 2 else {
                        throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                    }
                    
                    let retryResult = await interceptor.retry(finalRequest, dueTo: .success(httpResponse))
                    
                    switch retryResult {
                    case .retry:
                        // 재귀 호출
                        return try await performRequest(request, endpoint: endpoint, type: type, retryCount: retryCount + 1)
                    case .doNotRetryWithError(let error):
                        throw error
                    case .doNotRetry:
                        break // 에러 던지기로 진행
                    default: break
                    }
                }
                
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 4. Decoding
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch {
            // 5. Retry Check (네트워크 에러 기반)
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
}
