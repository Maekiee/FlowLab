import SwiftUI

@MainActor @Observable
final class DIContainer {
    let tokenManager: TokenManagerProtocol
    let apiClient: ApiClientProtocol
    let keychainManager: KeychainServiceProtocol
    let chatLocalDataSource: ChatLocalDataSourceProtocol

    init() {
        self.keychainManager = KeychainService()

        let authApiClient = ApiClient(interceptor: nil)

        let tokenManager = TokenManager(
            keychain: keychainManager,
            apiClient: authApiClient
        )
        self.tokenManager = tokenManager

        let interceptor = Interceptor(tokenManager: tokenManager)
        self.apiClient = ApiClient(interceptor: interceptor)

        // Realm 로컬 데이터 소스 초기화
        do {
            self.chatLocalDataSource = try ChatLocalDataSource()
        } catch {
            fatalError("Realm 초기화 실패: \(error)")
        }
    }
}


// MARK: - Router Factory
extension DIContainer {
    @MainActor
    func makeAppRouter() -> AppRouter {
        return AppRouter(container: self, tokenManager: tokenManager)
    }
}


// MARK: - Repository
extension DIContainer {
    func makeSignUpRepository() -> SignUpRepositoryProtocol {
        return SignUpRepository(apiClient: apiClient)
    }

    func makeLoginRepository() -> LoginRepositoryProtocol {
        return LoginRepository(apiClient: apiClient)
    }
    
    func makeProfileTabRepository() -> ProfileTabRepositoryProtocol {
        return ProfileTabRepository(apiClient: apiClient)
    }
    
    func makeHomeTabRepository() -> HomeTabRepositoryProtocol {
        return HomeTabRepository(apiClient: apiClient)
    }
    
    func makeVideoTabRepository() -> VideoTabRepositoryProtocol {
        return VideoTabRepository(apiClient: apiClient)
    }
    
    func makeVideoDetailRepository() -> VideoDetailRepositoryProtocol {
        return VideoDetailRepository(apiClient: apiClient)
    }
    
    func makeEstateDetailRepository() -> EstateDetailRepositoryProtocol {
        return EstateDetailRepository(apiClient: apiClient)
    }
    
    func makeChattingTabRepository() -> ChattingTabRepositoryProtocol {
        return ChattingTabRepository(apiClient: apiClient)
    }
    
    func makeFriendListRepository() -> FriendListRepositoryProtocol {
        return FriendListRepository(apiClient: apiClient)
    }
    
    func makeChattingRoomRepository() -> ChattingRoomRepositoryProtocol {
        return ChattingRoomRepository(apiClient: apiClient, localDataSource: chatLocalDataSource)
    }
}


// MARK: - Store
extension DIContainer {
    @MainActor
    func makeSignUpStore(router: AppRouter) -> SignUpStore {
        let repository = makeSignUpRepository()
        return SignUpStore(
            repository: repository,
            tokenManager: tokenManager,
            router: router
        )
    }

    @MainActor
    func makeLoginStore(router: AppRouter) -> LoginStore {
        let repository = makeLoginRepository()
        return LoginStore(
            repository: repository,
            tokenManager: tokenManager,
            router: router
        )
    }
    
    @MainActor
    func makeProfileTabStore() -> ProfileTabStore {
        let repository = makeProfileTabRepository()
        return ProfileTabStore(
            repository: repository,
            tokenManager: tokenManager
        )
    }
    
    
    @MainActor
    func makeHomeTabStore(tabRouter: HomeRouter) -> HomeTabStore {
        let repository = makeHomeTabRepository()
        return HomeTabStore(
            repository: repository,
            tokenManager: tokenManager,
            tabRouter: tabRouter,
        )
    }
    
    @MainActor
    func makeVideoTabStore() -> VideoTabStroe {
        let repository = makeVideoTabRepository()
        return VideoTabStroe(
            repository: repository,
            tokenManager: tokenManager,
        )
    }
    
    @MainActor
    func makeChattingTabStore() -> ChattingTabStore {
        let repository = makeChattingTabRepository()
        return ChattingTabStore(
            repository: repository
        )
    }
    
    @MainActor
    func makeVideoDetailStore(videoId: String) -> VideoDetailStore {
        let repository = makeVideoDetailRepository()
        return VideoDetailStore(
            repository: repository,
            videoId: videoId
        )
    }
    
    @MainActor
    func makeEstateDetailStore(estateId: String) -> EstateDetailStore {
        let repository = makeEstateDetailRepository()
        return EstateDetailStore(
            repository: repository,
            estateId: estateId
        )
    }
    
    @MainActor
    func makeChattingRoomStore(roomId: String) -> ChattingRoomStore {
        let repository = makeChattingRoomRepository()
        return ChattingRoomStore(repository: repository, tokenManager: tokenManager, roomId: roomId)
    }

    @MainActor
    func makeFriendListStore() -> FriendListStore {
        let repository = makeFriendListRepository()
        return FriendListStore(repository: repository)
    }
}


// MARK: - View
extension DIContainer {
    @MainActor
    func makeStartAuthView() -> StartAuthView {
        return StartAuthView()
    }

    @MainActor
    func makeLoginView(router: AppRouter) -> LoginView {
        let store = makeLoginStore(router: router)
        return LoginView(store: store)
    }

    @MainActor
    func makeSignUpView(router: AppRouter) -> SignUpView {
        let store = makeSignUpStore(router: router)
        return SignUpView(store: store)
    }
    
    @MainActor
    func makeProfileTabView() -> ProfileTabView {
        let store = makeProfileTabStore()
        return ProfileTabView(store: store)
    }
    
    @MainActor
    func makeHomeTabView(tabRouter: HomeRouter) -> HomeTabView {
        let store = makeHomeTabStore(tabRouter: tabRouter)
        return HomeTabView(store: store)
    }
    
    @MainActor
    func makeVideoTabView() -> VideoTabView {
        let store = makeVideoTabStore()
        return VideoTabView(store: store)
    }
    
    @MainActor
    func makeChattingTabView() -> ChattingTabView {
        let store = makeChattingTabStore()
        return ChattingTabView(store: store)
    }
    
    @MainActor
    func makeVideoDetailView(videoId: String) -> VideoDetailView {
        let store = makeVideoDetailStore(videoId: videoId)
        return VideoDetailView(store: store)
    }
    
    @MainActor
    func makeEstateDetailView(estateId: String) -> EstateDetailView {
        let store = makeEstateDetailStore(estateId: estateId)
        return EstateDetailView(store: store)
    }
    
    @MainActor
    func makeChattingRoomView(roomId: String) -> ChattingRoomView {
        let store = makeChattingRoomStore(roomId: roomId)
        return ChattingRoomView(store: store)
    }

    @MainActor
    func makeFriendListView(onRoomCreated: @escaping (String) -> Void) -> FriendListView {
        let store = makeFriendListStore()
        return FriendListView(store: store, onRoomCreated: onRoomCreated)
    }
}
