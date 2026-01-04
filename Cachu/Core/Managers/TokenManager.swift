import Foundation

actor TokenManager: TokenManagerProtocol {
    
    private let keychain: KeychainManagerProtocol
    private let session: URLSession
    private let refreshURL: URL
    
    private var refreshTask: Task<Bool, Error>?
    
    // 현재 갱신 중인지 확인하는 플래그 (중복 요청 방지)
    private var isRefreshing = false
    
    init(
        keychain: KeychainManagerProtocol = KeychainManager(),
        session: URLSession = .shared,
        refreshURL: URL = URL(string:AppConfig.baseURL + "/auth/refresh")!
    ) {
        self.keychain = keychain
        self.session = session
        self.refreshURL = refreshURL
    }
    
    // MARK: - Token Access
    func getAccessToken() -> String? {
        guard let data = keychain.read(service: TokenKey.service, account: TokenKey.accessToken) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func getRefreshToken() -> String? {
        guard let data = keychain.read(service: TokenKey.service, account: TokenKey.refreshToken) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Token Management
    func saveTokens(accessToken: String, refreshToken: String) throws {
        if let accessData = accessToken.data(using: .utf8) {
            try keychain.save(data: accessData, service: TokenKey.service, account: TokenKey.accessToken)
        }
        if let refreshData = refreshToken.data(using: .utf8) {
            try keychain.save(data: refreshData, service: TokenKey.service, account: TokenKey.refreshToken)
        }
    }
    
    func clearTokens() throws {
        try keychain.delete(service: TokenKey.service, account: TokenKey.accessToken)
        try keychain.delete(service: TokenKey.service, account: TokenKey.refreshToken)
    }
    
    // MARK: - Refresh Logic (Task Coalescing Applied)
    func refreshTokens() async throws -> Bool {
        // 1. 이미 진행 중인 Task가 있다면 그 결과를 기다렸다가 반환 (Wait for existing task)
        if let existingTask = refreshTask {
            return try await existingTask.value
        }
        
        // 2. 새로운 Task 생성
        let task = Task<Bool, Error> {
            defer { self.refreshTask = nil } // 작업 종료 시 Task 초기화
            
            return try await performRefreshToken()
        }
        
        self.refreshTask = task
        return try await task.value
    }
    
    func performRefreshToken() async throws -> Bool {
        guard let refreshToken = getRefreshToken() else { return false }
        
        var request = URLRequest(url: refreshURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Bearer 포맷 등 서버 스펙에 맞게 수정
        let body = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Refresh Failed: Status Code Error")
                try? clearTokens()
                return false
            }
            
            let tokenData = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
            try saveTokens(accessToken: tokenData.accessToken, refreshToken: tokenData.refreshToken)
            
            print("✅ Token Refreshed Successfully")
            return true
            
        } catch {
            print("❌ Refresh Failed: \(error)")
            try? clearTokens()
            throw error // 필요 시 에러 전파
        }
    }
}
