import SwiftUI

// MARK: - Some Tab Routes
enum VideoTabRoute: Hashable {
    case detail(id: String)
}



@MainActor @Observable
final class VideoTabRouter: TabRouterProtocol {
    typealias Route = VideoTabRoute

    var path = NavigationPath()
    let container: DIContainer

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
