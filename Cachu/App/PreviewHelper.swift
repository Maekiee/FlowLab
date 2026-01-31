import SwiftUI

#if DEBUG

// MARK: - Mock Implementations

struct MockTokenManager: TokenManagerProtocol {
    func getAccessToken() async -> String? { "mock_access_token" }
    func getRefreshToken() async -> String? { "mock_refresh_token" }
    func saveTokens(accessToken: String, refreshToken: String) async throws {}
    func clearTokens() async throws {}
    func refreshTokens() async throws -> Bool { true }
    func tryAutoLogin() async -> Bool { true }
    func getFCMToken() async -> String? { "mock_fcm_token" }
}

struct MockHomeTabRepository: HomeTabRepositoryProtocol {
    func fetchBannerMain() async throws -> BannersDTO {
        return BannersDTO(data: [])
    }
    
    func fetchHomeTabTopItems() async throws -> [EstateEntity] {
        return []
    }
    
    func fetchHotProperties() async throws -> EstateGeoListResponseDTO {
        return EstateGeoListResponseDTO(data: [])
    }
    
    func fetchDailyRealEstateTopics() async throws -> DailyRealEstateTopicsDTO {
        return DailyRealEstateTopicsDTO(data: [])
    }
}

// MARK: - Preview Container

@MainActor
final class PreviewContainer {
    static let shared = PreviewContainer()
    
    let container: DIContainer
    let appRouter: AppRouter
    let tokenManager: TokenManagerProtocol
    
    private init() {
        self.container = DIContainer()
        self.tokenManager = MockTokenManager()
        self.appRouter = AppRouter(container: container, tokenManager: tokenManager)
    }
    
    func makeHomeTabStore() -> HomeTabStore {
        return HomeTabStore(
            repository: MockHomeTabRepository(),
            tokenManager: tokenManager,
            tabRouter: appRouter.homeRouter
        )
    }
}

// MARK: - Preview Wrapper

struct PreviewWrapper<Content: View>: View {
    let content: (PreviewContainer) -> Content
    
    init(@ViewBuilder content: @escaping (PreviewContainer) -> Content) {
        self.content = content
    }
    
    var body: some View {
        let preview = PreviewContainer.shared
        
        content(preview)
            .environment(preview.appRouter)
            .environment(preview.appRouter.homeRouter)
            .environment(preview.appRouter.profileRouter)
            .environment(preview.appRouter.videoRouter)
    }
}

#endif
