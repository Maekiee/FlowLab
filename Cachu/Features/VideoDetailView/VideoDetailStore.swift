import Foundation
import Combine

@MainActor
@Observable
final class VideoDetailStore: StoreProtocol {
    
    struct State {
        var isLoading: Bool = false
        var errorMessage: String?
        var videoId: String = ""
    }
    
    enum Intent {
        case onAppear
    }
    
    enum SideEffect {
        case showErrorAlert(String)
    }
    
    private(set) var state = State()
    private let repository: VideoDetailRepositoryProtocol
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    
    init(repository: VideoDetailRepositoryProtocol, videoId: String) {
        self.repository = repository
        self.state.videoId = videoId
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getVideoStream()
        }
    }
}


extension VideoDetailStore {
    private func getVideoStream() {
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false}
            
            do {
                let res = try await repository.fetchVideo(videoId: state.videoId)
                print("비디오 응답값")
                
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
}
