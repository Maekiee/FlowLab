import SwiftUI

// MARK: - Router Protocol
@MainActor
protocol RouterProtocol: AnyObject, Observable {
    associatedtype Route: Hashable

    var path: NavigationPath { get set }

    func push(_ route: Route)

    func pop()

    func popToRoot()
}

// MARK: - Default Implementation
extension RouterProtocol {
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

// MARK: - View Building Protocol
@MainActor
protocol ViewBuildable {
    associatedtype Route: Hashable
    associatedtype DestinationView: View

    /// Route에 해당하는 View 생성
    @ViewBuilder func buildView(for route: Route) -> DestinationView
}
