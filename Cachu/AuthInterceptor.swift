//
//  AuthInterceptor.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation


final class AuthInterceptor: InterceptorProtocol {
    
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        self.tokenManager = tokenManager
    }
    
    // 요청 전: Access Token 주입
    func adapt(_ request: URLRequest) async -> URLRequest {
        var adaptedRequest = request
        if let token = await tokenManager.getAccessToken() {
            adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return adaptedRequest
    }
    
    // 응답 후: 401 발생 시 토큰 갱신 및 재시도
    func retry(_ request: URLRequest, with response: HTTPURLResponse) async -> URLRequest? {
        guard response.statusCode == 401 else { return nil }
        
        // 무한 루프 방지
        if let path = request.url?.path, path.contains("/auth/refresh") {
            return nil
        }
        
        guard let refreshToken = await tokenManager.getRefreshToken() else { return nil }
        
        do {
            let newTokens = try await refreshTokens(refreshToken: refreshToken)
            await tokenManager.saveTokens(access: newTokens.access, refresh: newTokens.refresh)
            return await adapt(request) // 갱신된 토큰으로 재요청 구성
        } catch {
            await tokenManager.clearTokens()
            return nil
        }
    }
    
    private func refreshTokens(refreshToken: String) async throws -> (access: String, refresh: String) {
        let endpoint = APIEndpoint.refresh(token: refreshToken)
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        endpoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.body ?? [:])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.unauthorized }
        
        struct RefreshResponse: Decodable { let accessToken: String; let refreshToken: String }
        let decoded = try JSONDecoder().decode(RefreshResponse.self, from: data)
        return (decoded.accessToken, decoded.refreshToken)
    }
}
