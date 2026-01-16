import Foundation

actor TokenManager: TokenManagerProtocol {
    private let keychain: KeychainServiceProtocol
    private let apiClient: ApiClientProtocol
    private var refreshTask: Task<Bool, Error>?

    init(
        keychain: KeychainServiceProtocol,
        apiClient: ApiClientProtocol
    ) {
        self.keychain = keychain
        self.apiClient = apiClient
    }
    
    // MARK: - Token Access
    func getAccessToken() -> String? {
        guard let data = keychain.read(
            service: AppConfig.bundleID,
            account: AppConfig.accessTokenKey
        ) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func getRefreshToken() -> String? {
        guard let data = keychain.read(
            service: AppConfig.bundleID,
            account: AppConfig.refreshTokenKey
        ) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    // MARK: - FCM Token
    func getFCMToken() -> String? {
        guard let data = keychain.read(
            service: AppConfig.bundleID,
            account: AppConfig.fcmTokenKey
        ) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// 토큰 저장
    func saveTokens(accessToken: String, refreshToken: String) async throws {
        if let accessData = accessToken.data(using: .utf8) {
            try await keychain.save(
                data: accessData,
                service: AppConfig.bundleID,
                account: AppConfig.accessTokenKey
            )
        }
        
        if let refreshData = refreshToken.data(using: .utf8) {
            try await keychain.save(
                data: refreshData,
                service: AppConfig.bundleID,
                account: AppConfig.refreshTokenKey
            )
        }
    }
    
    // 토큰 정리
    func clearTokens() async throws {
        try await keychain.delete(service: AppConfig.bundleID, account: AppConfig.accessTokenKey)
        try await keychain.delete(service: AppConfig.bundleID, account: AppConfig.refreshTokenKey)
    }
    
    // MARK: - Refresh Logic (Task Coalescing Applied)
    func refreshTokens() async throws -> Bool {
        // 1. 이미 진행 중인 Task가 있다면 그 결과를 기다렸다가 반환 (Wait for existing task)
        if let existingTask = refreshTask {
            return try await existingTask.value
        }
        
        let task = Task<Bool, Error> {
            defer { self.refreshTask = nil }
            
            return try await performRefreshToken()
        }
        
        self.refreshTask = task
        return try await task.value
    }
    
    // 토큰 갱신
    func performRefreshToken() async throws -> Bool {
        guard let accessToken = getAccessToken(),
              let refreshToken = getRefreshToken() else {
            print("⚠️ 토큰 갱신 실패: 기존 토큰이 없음")
            return false
        }

        print("🔄 토큰 갱신 시도 - 이전 토큰: \(accessToken.suffix(20))")

        do {
            let response = try await apiClient.request(
                ApiEndpoint.refresh(accessToken: accessToken, refreshToken: refreshToken),
                type: RefreshTokenResponseDTO.self
            )

            print("🆕 새 토큰 수신: \(response.accessToken.suffix(20))")

            try await saveTokens(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken
            )

            // 저장 후 확인
            if let savedToken = getAccessToken() {
                print("💾 저장된 토큰: \(savedToken.suffix(20))")
            } else {
                print("❌ 토큰 저장 실패!")
            }

            print("✅ 토큰 갱신 성공")
            return true
        } catch {
            print("❌ Refresh Failed: \(error)")
            try? await clearTokens()
            throw error
        }
    }

    // 자동 로그인
    func tryAutoLogin() async -> Bool {
        guard getAccessToken() != nil else {
            print("🔑 엑세스 토큰이 없음 처음 실행한 유저")
            return false
        }

        // 액세스 토큰이 있으면 토큰 갱신 시도
        do {
            let success = try await refreshTokens()
            if success {
                print("✅ 자동 로그인 성공")
            }
            return success
        } catch {
            print("❌ 자동 로그인 실패: \(error)")
            return false
        }
    }
}
