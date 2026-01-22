import Foundation
import Combine

@MainActor
@Observable
final class HomeTabStore: StoreProtocol {
    struct State {
        var isLoading = false
        var accessToken: String?  
        var errorMessage: String?
        var homeTabTopItems: [HomeTabTopItem] = []
        var hotItems: [EstateSummaryResponseDTO] = []
        var dailyTopics: [DailyRealEstateDTO] = []
        var mainBanners: [BannerDTO] = []
        var searchInput = ""
    }
    
    enum Intent {
        case onAppear
        case searchInput(String)
        case didTapBanner(BannerDTO)
    }
    
    enum SideEffect {
        case showErrorAlert(String)
        case routeTo(HomeRoute)
    }
    
    private(set) var state = State()
    private let repository: HomeTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: HomeTabRepositoryProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            fetchHomeTabData()
        case .searchInput(let input):
            state.searchInput = input
        case .didTapBanner(let banner):
            handleBannerTap(banner)
        }
    }
}

extension HomeTabStore {
    private func fetchHomeTabData() {
        Task {
            state.isLoading = true
            state.accessToken = await tokenManager.getAccessToken()

            defer { state.isLoading = false }

            do {
                async let responseHomeTabItems = try await repository.fetchHomeTabTopItems()
                async let responseHotProperties = try await repository.fetchHotProperties()
                async let responseDailyEstateTopics = try await repository.fetchDailyRealEstateTopics()
                async let responseBannerMain = try await repository.fetchBannerMain()
                

                let (homeTopItems, hotItem, dailyTopic, banner) = try await (responseHomeTabItems, responseHotProperties, responseDailyEstateTopics, responseBannerMain)
                
               
                state.homeTabTopItems = homeTopItems.data
                state.hotItems = hotItem.data
                state.dailyTopics = dailyTopic.data
                state.mainBanners = banner.data
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch  {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
    
    // playload 분석 및 url 생성 로직
    private func handleBannerTap(_ banner: BannerDTO) {
        let payload = banner.payload
        
        guard payload.type == "WEBVIEW" else { return }
        let fullPath = AppConfig.baseURLWeb + payload.value
        
        if let url = URL(string: fullPath) {
            effectSubject.send(.routeTo(.webView(url: url)))
        } else {
            effectSubject.send(.showErrorAlert("유효하지 않은 링크 입니다."))
        }
    }
}
