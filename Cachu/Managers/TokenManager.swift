import Foundation

actor TokenManager: TokenManagerProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let session: URLSession
    
    // 현재 갱신 중인지 확인하는 플래그 (중복 요청 방지)
    private var isRefreshing = false
    
    public init(keychain: KeychainManagerProtocol = KeychainManager(), session: URLSession = .shared) {
        self.keychain = keychain
        self.session = session
    }
    
    // MARK: - Token Access
    public func getAccessToken() -> String? {
        guard let data = keychain.read(service: TokenKey.service, account: TokenKey.accessToken) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func getRefreshToken() -> String? {
        guard let data = keychain.read(service: TokenKey.service, account: TokenKey.refreshToken) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Token Management
    public func saveTokens(accessToken: String, refreshToken: String) throws {
        if let accessData = accessToken.data(using: .utf8) {
            try keychain.save(data: accessData, service: TokenKey.service, account: TokenKey.accessToken)
        }
        if let refreshData = refreshToken.data(using: .utf8) {
            try keychain.save(data: refreshData, service: TokenKey.service, account: TokenKey.refreshToken)
        }
    }
    
    public func clearTokens() throws {
        try keychain.delete(service: TokenKey.service, account: TokenKey.accessToken)
        try keychain.delete(service: TokenKey.service, account: TokenKey.refreshToken)
    }
    
    // MARK: - Refresh Logic
    public func refreshTokens() async throws -> Bool {
        // 1. 이미 갱신 중이라면 대기하거나 실패 처리 (여기서는 간단히 false 반환하거나, Task를 공유하는 로직 추가 가능)
        if isRefreshing { return false }
        isRefreshing = true
        
        // defer 블록을 사용하여 메서드가 끝나면 무조건 플래그 해제
        defer { isRefreshing = false }
        
        guard let refreshToken = getRefreshToken() else { return false }
        
        // 2. 리프레시 API 호출
        // ⚠️ 중요: 여기서 NetworkClient를 쓰면 Interceptor가 다시 끼어들어 무한 루프 가능성 있음.
        // 따라서 순수 URLSession이나 별도의 AuthAPI를 호출해야 함.
        guard let url = URL(string: "https://api.example.com/auth/refresh") else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // 갱신 실패 시 로그아웃 처리 등을 위해 토큰 삭제
                try? clearTokens()
                return false
            }
            
            let tokenData = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
            
            // 3. 새로운 토큰 저장
            try saveTokens(accessToken: tokenData.accessToken, refreshToken: tokenData.refreshToken)
            print("✅ Token Refreshed Successfully")
            return true
            
        } catch {
            print("❌ Token Refresh Failed: \(error)")
            try? clearTokens()
            return false
        }
    }
}
