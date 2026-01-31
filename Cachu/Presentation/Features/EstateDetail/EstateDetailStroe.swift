import Foundation
import Combine



@MainActor @Observable
final class EstateDetailStore: StoreProtocol {
    private(set) var state = State()
    private let repository: EstateDetailRepositoryProtocol
    
    init(
        repository: EstateDetailRepositoryProtocol,
    ) {
        self.repository = repository
    }
    
    struct State {
        
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
