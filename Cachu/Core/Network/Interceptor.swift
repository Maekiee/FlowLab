import Foundation


final class Interceptor: InterceptorProtocol {
    private let tokenManager: TokenManagerProtocol
    
    init(tokenManager: TokenManagerProtocol) {
        self.tokenManager = tokenManager
    }
    
    func adapt(_ request: URLRequest, for endpoint: Endpoint) async -> URLRequest {
        // ✅ 성능 최적화: 인증이 불필요한 엔드포인트는 로직 수행 없이 즉시 리턴
        guard endpoint.requiresAuth else { return request }
        
        var adaptedRequest = request
        if let token = await tokenManager.getAccessToken() {
            adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return adaptedRequest
    }
    
    func retry(_ request: URLRequest, dueTo result: Result<HTTPURLResponse, Error>) async -> RetryResult {
        switch result {
        case .success(let response):
            // 401 Unauthorized 발생 시 토큰 갱신 시도
            if response.statusCode == 401 {
                print("🔄 [AuthInterceptor] 401 Detected. Refreshing Token...")
                do {
                    let isRefreshed = try await tokenManager.refreshTokens()
                    return isRefreshed ? .retry : .doNotRetry
                } catch {
                    return .doNotRetryWithError(error)
                }
            }
            return .doNotRetry
            
        case .failure(let error):
            // 네트워크 에러(오프라인 등)는 여기서 처리하거나 Pass
            // 필요하다면 연결 대기 후 .retry 반환 가능
            return .doNotRetryWithError(error)
        }
    }
}
