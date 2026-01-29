import Foundation


final class Interceptor: InterceptorProtocol {
    private let tokenManager: TokenManagerProtocol
    
    init(tokenManager: TokenManagerProtocol) {
        self.tokenManager = tokenManager
    }
    
    func adapt(_ request: URLRequest, for endpoint: Endpoint) async -> URLRequest {
        guard endpoint.requiresAuth else { return request }

        var adaptedRequest = request
        if let token = await tokenManager.getAccessToken() {
            adaptedRequest.setValue(token, forHTTPHeaderField: "Authorization")
        } 

        return adaptedRequest
    }
    
    func retry(_ request: URLRequest, dueTo result: Result<HTTPURLResponse, Error>) async -> RetryResult {
        switch result {
        case .success(let response):
            // 418: 리프레시 토큰 만료 - 재로그인 필요
            if response.statusCode == 418 {
                await clearTokensAndNotify()
                await AuthEventManager.shared.send(.sessionExpired)
                return .doNotRetryWithError(NetworkError.refreshTokenExpired("리프레시 토큰이 만료되었습니다."))
            }

            // 401 또는 419: 액세스 토큰 만료 - 토큰 갱신 시도
            if response.statusCode == 401 || response.statusCode == 419 {
                do {
                    let isRefreshed = try await tokenManager.refreshTokens()
                    return isRefreshed ? .retry : .doNotRetry
                } catch {
                    return .doNotRetryWithError(error)
                }
            }
            return .doNotRetry

        case .failure(let error):
            return .doNotRetryWithError(error)
        }
    }

    private func clearTokensAndNotify() async {
        try? await tokenManager.clearTokens()
    }
}
