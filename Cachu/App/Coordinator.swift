import Foundation
import SwiftUI
import Observation
import Combine

enum AppRoute: Hashable {
    case startAuth
    case signup
    case main
}

enum SheetRoute: Identifiable {
    case someView
    
    var id: String {
        switch self {
        case .someView: return "someView"
        }
    }
}

enum FullScreenSheetRoute: Identifiable {
    case emailLogin
    
    var id: String {
        switch self {
        case .emailLogin: return "emailLogin"
        }
    }
}

protocol CoordinatorProtocol {
    func push(_ route: AppRoute)
    func pop()
    func setRoot(_ route: AppRoute)
    
    func present(sheet: SheetRoute)
    func dismissSheet()
    
    func present(fullScreen: FullScreenSheetRoute)
    func dismissFullScreen()
}


@MainActor
protocol AppViewFactory {
    func makeStartAuthView() -> AnyView
    func makeLoginView() -> AnyView
    func makeSignUpView() -> AnyView
    func makeMainView() -> AnyView
}

@MainActor
@Observable
final class Coordinator: CoordinatorProtocol {
    private let factory: AppViewFactory
    private let tokenManager: TokenManagerProtocol

    // MARK: - App Level Navigation
    var navigationPath = NavigationPath()
    var rootRoute: AppRoute = .startAuth
    var sheetRoute: SheetRoute?
    var fullScreenSheetRoute: FullScreenSheetRoute?
    var isCheckingAuth = true

    // MARK: - Tab Navigation
    var selectedTab: MainTab = .home
    let homeCoordinator = HomeCoordinator()
    let mapCoordinator = MapCoordinator()
    let favoriteCoordinator = FavoriteCoordinator()
    let profileCoordinator = ProfileCoordinator()

    private var authEventTask: Task<Void, Never>?

    init(factory: AppViewFactory, tokenManager: TokenManagerProtocol) {
        self.factory = factory
        self.tokenManager = tokenManager

        subscribeAuthEvents()
    }

    // MARK: - Tab Methods
    func switchTab(to tab: MainTab) {
        selectedTab = tab
    }

    func resetAllTabs() {
        homeCoordinator.popToRoot()
        mapCoordinator.popToRoot()
        favoriteCoordinator.popToRoot()
        profileCoordinator.popToRoot()
        selectedTab = .home
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

    /// 세션 만료 시 로그인 화면으로 이동
    func handleSessionExpired() {
        dismissSheet()
        dismissFullScreen()
        resetAllTabs()
        setRoot(.startAuth)
    }

    /// 앱 시작 시 자동 로그인 체크
    func checkAutoLogin() async {
        let success = await tokenManager.tryAutoLogin()

        if success {
            setRoot(.main)
        } else {
            setRoot(.startAuth)
        }

        isCheckingAuth = false
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .startAuth:
            factory.makeStartAuthView()
        case .signup:
            factory.makeSignUpView()
        case .main:
            factory.makeMainView()
        }
    }
    
    @ViewBuilder
    func buildSheet(route: SheetRoute) -> some View {
        switch route {
        case .someView:
            Text("나중에 뷰 여기다가")
        }
    }
    
    @ViewBuilder
    func buildFullScreenSheet(route: FullScreenSheetRoute) -> some View {
        switch route {
        case .emailLogin:
            factory.makeLoginView()
        }
    }
    
    func push(_ route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func setRoot(_ route: AppRoute) {
        navigationPath = NavigationPath()
        rootRoute = route
    }
    
    func present(sheet: SheetRoute) {
        self.sheetRoute = sheet
    }
    
    func dismissSheet() {
        self.sheetRoute = nil
    }
    
    func present(fullScreen: FullScreenSheetRoute) {
        self.fullScreenSheetRoute = fullScreen
    }
    
    func dismissFullScreen() {
        self.fullScreenSheetRoute = nil
    }
    
    
}
