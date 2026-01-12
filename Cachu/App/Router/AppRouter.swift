import SwiftUI

// MARK: - AppRouter
/// 앱 전체 네비게이션을 관리하는 메인 Router
/// - 루트 뷰 상태 관리 (auth/main)
/// - Auth 플로우 네비게이션
/// - 자동 로그인 및 세션 만료 처리
/// - Tab Routers 보유
@MainActor
@Observable
final class AppRouter {

    // MARK: - Dependencies
    private let container: DIContainer
    private let tokenManager: TokenManagerProtocol

    // MARK: - Root View State
    /// 현재 루트 뷰 상태 (자동 로그인 결과에 따라 결정)
    private(set) var rootView: AppRootView = .auth

    /// 자동 로그인 체크 중 여부
    private(set) var isCheckingAuth: Bool = true

    // MARK: - Auth Flow Navigation
    /// 인증 플로우 네비게이션 경로 (StartAuth → Login/SignUp)
    var authPath = NavigationPath()

    // MARK: - Sheet & FullScreen
    var sheetRoute: SheetRoute?
    var fullScreenRoute: FullScreenRoute?

    // MARK: - Tab State
    var selectedTab: MainTab = .home

    // MARK: - Tab Routers
    let homeRouter: HomeRouter
    let someRouter: SomeRouter
    let profileRouter: ProfileRouter

    // MARK: - Auth Event Task
    nonisolated(unsafe) private var authEventTask: Task<Void, Never>?

    // MARK: - Initialization
    init(container: DIContainer, tokenManager: TokenManagerProtocol) {
        self.container = container
        self.tokenManager = tokenManager

        // Tab Routers 초기화
        self.homeRouter = HomeRouter(container: container)
        self.someRouter = SomeRouter(container: container)
        self.profileRouter = ProfileRouter(container: container)

        subscribeAuthEvents()
    }

    deinit {
        authEventTask?.cancel()
    }

    // MARK: - Auto Login
    /// 앱 시작 시 자동 로그인 체크
    func checkAutoLogin() async {
        isCheckingAuth = true
        defer { isCheckingAuth = false }

        let success = await tokenManager.tryAutoLogin()

        if success {
            switchToMain()
        } else {
            switchToAuth()
        }
    }

    // MARK: - Root View Transition
    /// 메인 화면으로 전환 (로그인/회원가입 성공 시)
    func switchToMain() {
        authPath = NavigationPath()
        withAnimation {
            rootView = .main
        }
    }

    /// 인증 화면으로 전환 (로그아웃/세션 만료 시)
    func switchToAuth() {
        resetAllTabRouters()
        withAnimation {
            rootView = .auth
        }
    }

    // MARK: - Auth Flow Navigation
    /// Auth 플로우 내 화면 push (Login/SignUp)
    func pushAuth(_ route: AuthRoute) {
        authPath.append(route)
    }

    /// Auth 플로우 내 화면 pop
    func popAuth() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }

    /// Auth 플로우 루트로 이동
    func popAuthToRoot() {
        authPath = NavigationPath()
    }

    // MARK: - Sheet Presentation
    func presentSheet(_ route: SheetRoute) {
        sheetRoute = route
    }

    func dismissSheet() {
        sheetRoute = nil
    }

    // MARK: - FullScreen Presentation
    func presentFullScreen(_ route: FullScreenRoute) {
        fullScreenRoute = route
    }

    func dismissFullScreen() {
        fullScreenRoute = nil
    }

    // MARK: - Tab Navigation
    func switchTab(to tab: MainTab) {
        selectedTab = tab
    }

    // MARK: - Session Expired
    /// 세션 만료 시 처리 (로그인 화면으로 이동)
    func handleSessionExpired() {
        dismissSheet()
        dismissFullScreen()
        switchToAuth()
    }

    // MARK: - Auth Event Subscription
    private func subscribeAuthEvents() {
        authEventTask = Task {
            for await event in await AuthEventManager.shared.events {
                switch event {
                case .sessionExpired:
                    handleSessionExpired()
                }
            }
        }
    }

    // MARK: - Reset Tab Routers
    private func resetAllTabRouters() {
        homeRouter.popToRoot()
        someRouter.popToRoot()
        profileRouter.popToRoot()
        selectedTab = .home
    }
}

// MARK: - Auth View Building
extension AppRouter {
    /// Auth Route에 해당하는 View 생성
    @ViewBuilder
    func buildAuthView(for route: AuthRoute) -> some View {
        switch route {
        case .login:
            container.makeLoginView(router: self)
        case .signUp:
            container.makeSignUpView(router: self)
        }
    }
}
