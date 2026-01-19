import Foundation
import Combine

@MainActor
@Observable
final class HomeTabStore: StoreProtocol {
    struct State {
        var isLoading = false
        var errorMessage: String?
        var bannerItems: [EstateSummaryResponseDTO] = []
        var hotItems: [EstateSummaryResponseDTO] = []
        var dailyTopics: [DailyRealEstateDTO] = []
        var searchInput = ""
    }
    
    enum Intent {
        case onAppear
        case searchInput(String)
    }
    
    enum SideEffect {
        case showErrorAlert(String)
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
        }
    }
}

extension HomeTabStore {
    private func fetchHomeTabData() {
        Task {
            state.isLoading = true
    
            defer { state.isLoading = false }
            
            do {
                async let responseBanner = try await repository.getBanner()
                async let responseHotProperties = try await repository.getHotProperties()
                async let responseDailyEstateTopics = try await repository.getDailyRealEstateTopics()
                
                let (banner, hotItem, dailyTopic) = try await (responseBanner, responseHotProperties, responseDailyEstateTopics)
                
                state.bannerItems = banner.data
                state.hotItems = hotItem.data
                state.dailyTopics = dailyTopic.data
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch  {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
}
