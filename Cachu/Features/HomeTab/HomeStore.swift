import Foundation
import Combine

@MainActor
@Observable
final class HomeStore {
    // MARK: - State
    struct State {
        var properties: [String] = []
        var isLoading = false
        var errorMessage: String?
    }

    // MARK: - Intent
    enum Intent {
        case onAppear
        case refresh
        case tapPropertyList
        case tapPropertyDetail(id: String)
        case tapNotification
        case dismissError
    }

    // MARK: - SideEffect
    enum SideEffect: Equatable {
        case navigateToPropertyList
        case navigateToPropertyDetail(id: String)
        case navigateToNotification
    }

    // MARK: - Properties
    private(set) var state = State()
    private let effectSubject = PassthroughSubject<SideEffect, Never>()

    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }

    // MARK: - Init
    init() {
        // TODO: Repository 주입
    }

    // MARK: - Action
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            guard state.properties.isEmpty else { return }
            fetchProperties()

        case .refresh:
            fetchProperties()

        case .tapPropertyList:
            effectSubject.send(.navigateToPropertyList)

        case .tapPropertyDetail(let id):
            effectSubject.send(.navigateToPropertyDetail(id: id))

        case .tapNotification:
            effectSubject.send(.navigateToNotification)

        case .dismissError:
            state.errorMessage = nil
        }
    }

    // MARK: - Private Methods
    private func fetchProperties() {
        state.isLoading = true

        Task {
            // TODO: Repository를 통한 실제 데이터 Fetch
            try? await Task.sleep(for: .seconds(1))

            state.properties = ["property-1", "property-2", "property-3"]
            state.isLoading = false
        }
    }
}
