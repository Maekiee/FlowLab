import SwiftUI
import iamport_ios

// MARK: - Payment Response
struct PaymentResponseData {
    let impUid: String?
    let merchantUid: String?
    let success: Bool
}

// MARK: - App Root View
enum AppRootView: Equatable {
    case auth // 로그인 전
    case main // 로그인 후
}

// MARK: - Auth Routes
enum AuthRoute: Hashable {
    case login
    case signUp
}

// MARK: - Sheet Routes
enum SheetRoute: Identifiable, Hashable {
    case sample

    var id: String {
        switch self {
        case .sample:
            return "sample"
        }
    }
}

// MARK: - FullScreen Routes
enum FullScreenRoute: Identifiable, Hashable {
    case payment(totalPrice: Int)
    var id: String {
        switch self {
        case .payment:
            return "payment"
        }
    }
}

// MARK: - Main Tab
enum MainTab: Int, Hashable, CaseIterable {
    case home = 0
    case video = 1
    case profile = 2

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .video:
            return "탭2"
        case .profile:
            return "내 정보"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .video:
            return "square.grid.2x2"
        case .profile:
            return "person"
        }
    }
}



// MARK: - AppRouter
@MainActor @Observable
final class AppRouter {

    private let container: DIContainer
    private let tokenManager: TokenManagerProtocol

    private(set) var rootView: AppRootView = .auth
    private(set) var isCheckingAuth: Bool = true

    var authPath = NavigationPath()

    var sheetRoute: SheetRoute?
    var fullScreenRoute: FullScreenRoute?
    var paymentResponse: PaymentResponseData?

    var selectedTab: MainTab = .home

    let homeRouter: HomeRouter
    let videoRouter: VideoTabRouter
    let profileRouter: ProfileRouter

    nonisolated(unsafe) private var authEventTask: Task<Void, Never>?

    init(container: DIContainer, tokenManager: TokenManagerProtocol) {
        self.container = container
        self.tokenManager = tokenManager

        // Tab Routers 초기화
        self.homeRouter = HomeRouter(container: container)
        self.videoRouter = VideoTabRouter(container: container)
        self.profileRouter = ProfileRouter(container: container)

        subscribeAuthEvents()
    }

    deinit {
        authEventTask?.cancel()
    }

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
    
    /// 메인 화면으로 전환 (로그인/회원가입 성공 시)
    func switchToMain() {
        authPath = NavigationPath()
        withAnimation {
            rootView = .main
        }

        Task {
            if let accessToken = await tokenManager.getAccessToken() {
                print("🔐 메인 화면 진입 - AccessToken: \(accessToken)")
            }
        }
    }

    /// 인증 화면으로 전환 (로그아웃/세션 만료 시)
    private func switchToAuth() {
        resetAllTabRouters()
        withAnimation {
            rootView = .auth
        }
    }

    
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

    func presentSheet(_ route: SheetRoute) {
        sheetRoute = route
    }

    func dismissSheet() {
        sheetRoute = nil
    }

    func presentFullScreen(_ route: FullScreenRoute) {
        fullScreenRoute = route
    }

    func dismissFullScreen() {
        fullScreenRoute = nil
    }

    func completePayment(response: IamportResponse?) {
        paymentResponse = PaymentResponseData(
            impUid: response?.imp_uid,
            merchantUid: response?.merchant_uid,
            success: response?.success ?? false
        )
        dismissFullScreen()
    }

    func switchTab(to tab: MainTab) {
        selectedTab = tab
    }

    func handleSessionExpired() {
        dismissSheet()
        dismissFullScreen()
        switchToAuth()
    }

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

    private func resetAllTabRouters() {
        homeRouter.popToRoot()
        videoRouter.popToRoot()
        profileRouter.popToRoot()
        selectedTab = .home
    }
}

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
