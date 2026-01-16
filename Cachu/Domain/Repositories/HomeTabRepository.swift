import Foundation



final class HomeTabRepository: HomeTabRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getBanner() {
        print("베너 가져오기")
    }
}
