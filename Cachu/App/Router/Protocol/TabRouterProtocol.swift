import SwiftUI

// MARK: - Tab Router Protocol
/// 각 탭별 독립적인 네비게이션을 관리하는 Router
/// DI Container를 통해 View를 생성하는 책임 포함
@MainActor
protocol TabRouterProtocol: RouterProtocol, ViewBuildable {
    /// 의존성 주입을 위한 Container 참조
    var container: DIContainer { get }
}

// MARK: - Default Implementation
extension TabRouterProtocol {
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
