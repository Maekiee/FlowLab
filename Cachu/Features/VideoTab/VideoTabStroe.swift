import Foundation
import Combine

@MainActor
@Observable
final class VideoTabStroe: StoreProtocol {
    struct State {
        var isLoading = false
        var videoList: [VideoDTO] = []
    }
    
    enum Intent {
        case onAppear
        case didTapVideo(String)
    }
    
    enum SideEffect {
        case showErrorAlert(String)
        case routeTo(VideoTabRoute)
    }
    
    private(set) var state = State()
    private let repository: VideoTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: VideoTabRepositoryProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getVideoList()
        case .didTapVideo(let id):
            effectSubject.send(.routeTo(.detail(id: id)))
        }
    }
}

extension VideoTabStroe {
    private func getVideoList() {
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false }
            
            do {
                let responseVideoList = try await repository.fetchVideoList()
                let responseList = responseVideoList.data
                state.videoList = responseList
                
                
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
}
