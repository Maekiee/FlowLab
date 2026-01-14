import SwiftUI

@MainActor
protocol TabRouterProtocol: RouterProtocol, ViewBuildable {
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
