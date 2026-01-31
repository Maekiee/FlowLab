import Foundation
import Combine



@MainActor @Observable
final class EstateDetailStore: StoreProtocol {
    private(set) var state = State()
    private let repository: EstateDetailRepositoryProtocol
    
    init(
        repository: EstateDetailRepositoryProtocol,
        estateId: String
    ) {
        self.repository = repository
        self.state.stateId = estateId
    }
    
    struct State {
        var stateId: String = ""
    }
    
    enum Intent {
        
    }
    
    enum SideEffect {
        
    }
    
    func action(_ intent: Intent) {
        
    }
}


extension EstateDetailStore {
    
}
