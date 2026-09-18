import Foundation
import Combine

@MainActor
@Observable
final class VideoDetailStore: StoreProtocol {
    
    struct State {
        var isLoading: Bool = false
        var errorMessage: String?
        var videoId: String = ""
        var streamURL: URL?
        
        var masterURL: URL?          // "Auto" 모드용 원본 URL (백업용)
        var qualities: [StreamQualityDTO] = [] // 화질 목록
        var currentQualityName: String = "Auto" //
    }
    
    enum Intent {
        case onAppear
        case changeQuality(StreamQualityDTO?)
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
        case .changeQuality(let quality):
            updateQuality(quality)
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
                
                if let masterPath = URL(string: AppConfig.baseURL + res.stream_url) {
                    state.masterURL = masterPath
                    state.streamURL = masterPath
                    print("재생")
                }
                
                state.qualities = res.qualities
                state.currentQualityName = "Auto"
                
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
    
    private func updateQuality(_ quality: StreamQualityDTO?) {
        if let quality = quality {
            if let newPath = URL(string: AppConfig.baseURL + quality.url) {
                state.streamURL = newPath
                state.currentQualityName = quality.quality
                print("화질 변경: \(quality.quality)")
            }
        } else {
            state.streamURL = state.masterURL
            state.currentQualityName = "Auto"
            print("화질 변경: Auto")
        }
    }
}
