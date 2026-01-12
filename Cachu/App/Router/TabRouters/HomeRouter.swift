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

    // MARK: - Initialization
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - View Building
    @ViewBuilder
    func buildView(for route: HomeRoute) -> some View {
        switch route {
        case .propertyDetail(let id):
            // TODO: PropertyDetailView 구현 후 연결
            Text("Property Detail: \(id)")
        case .propertyList:
            // TODO: PropertyListView 구현 후 연결
            Text("Property List")
        case .notification:
            // TODO: NotificationView 구현 후 연결
            Text("Notification")
        }
    }
}
