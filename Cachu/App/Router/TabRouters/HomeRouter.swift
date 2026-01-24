import SwiftUI

// MARK: - HomeRouter
/// 홈 탭의 독립적인 네비게이션을 관리하는 Router
@MainActor
@Observable
final class HomeRouter: TabRouterProtocol {
    typealias Route = HomeRoute

    // MARK: - Properties
    var path = NavigationPath()
    let container: DIContainer

    // MARK: - FullScreen WebView
    var fullScreenWebViewURL: URL?

    // MARK: - Initialization
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - FullScreen Presentation
    func presentFullScreenWebView(url: URL) {
        fullScreenWebViewURL = url
    }

    func dismissFullScreenWebView() {
        fullScreenWebViewURL = nil
    }

    // MARK: - View Building
    @ViewBuilder
    func buildView(for route: HomeRoute) -> some View {
        switch route {
        default:
            Text("")
        }
    }
}
