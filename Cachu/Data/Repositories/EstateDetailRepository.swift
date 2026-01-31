import Foundation


final class EstateDetailRepository: EstateDetailRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension EstateDetailRepository {
    func fetchSomething() -> String {
        return "Hello world"
    }
}
