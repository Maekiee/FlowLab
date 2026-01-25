import SwiftUI

// MARK: - SomeRouter
/// Some 탭의 독립적인 네비게이션을 관리하는 Router
/// 추후 기능 확장 시 구체화
@MainActor
@Observable
final class VideoTabRouter: TabRouterProtocol {
    typealias Route = VideoTabRoute

    // MARK: - Properties
    var path = NavigationPath()
    let container: DIContainer

    // MARK: - Initialization
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - View Building
    @ViewBuilder
    func buildView(for route: VideoTabRoute) -> some View {
        switch route {
        case .detail(let id):
            container.makeVideoDetailView(videoId: id)
        }
    }
}
