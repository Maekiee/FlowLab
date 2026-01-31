import Foundation
import Combine



@MainActor @Observable
final class EstateDetailStore: StoreProtocol {
    private(set) var state = State()
    private let repository: EstateDetailRepositoryProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: EstateDetailRepositoryProtocol,
        estateId: String
    ) {
        self.repository = repository
        self.state.estateId = estateId
    }
    
    struct State {
        var isLoading = false
        var estateId = ""
        var errorMessage: String?
    }
    
    enum Intent {
        case onAppear
        
    }
    
    enum SideEffect {
        case showErrorAlert(String)
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getEstateDetail()
        }
    }
}


extension EstateDetailStore {
    private func getEstateDetail() {
        print("실행 실행")
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false }
            
            do {
                let estateDetail = try await repository.fetchEstateDetail(estateId: state.estateId)
                print(estateDetail)
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
}
