import Foundation
import Combine

@MainActor @Observable
final class ChattingTabStore: StoreProtocol {
    private(set) var state = State()
    private let repository: ChattingTabRepositoryProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: ChattingTabRepositoryProtocol
    ) {
        self.repository = repository
    }
    
    struct State {
        var isLoading = false
        var chatRooms: [ChatRoomEntity] = []
        var errorMessage: String?
    }
    
    enum Intent {
        case onAppear
    }
    
    enum SideEffect {
        case showAlert(String)
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getChattingRoomList()
        }
    }
}


extension ChattingTabStore {
    
    private func getChattingRoomList() {
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false }
            
            do {
                let chatList = try await repository.fetchChatRoomList()
                print("----- 데이터 가져옴 ---- ")
                state.chatRooms = chatList
            } catch let error as NetworkError {
                print("네트워크 에러 입니다")
                effectSubject.send(.showAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showAlert(error.localizedDescription))
            }
        }
    }
}
