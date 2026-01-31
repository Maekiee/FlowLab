import SwiftUI


enum HomeRoute: Hashable {
    case webView(url: URL)
    case estateDetail(estateId: String)
}

@MainActor @Observable
final class HomeRouter: TabRouterProtocol {
    typealias Route = HomeRoute

    var path = NavigationPath()
    let container: DIContainer

    var fullScreenWebViewURL: URL?

    init(container: DIContainer) {
        self.container = container
    }
}


extension HomeRouter {
    @ViewBuilder
    func buildView(for route: HomeRoute) -> some View {
        switch route {
        case .estateDetail(let estateId):
            container.makeEstateDetailView(estateId: estateId)
        default:
            Text("")
        }
    }
}


extension HomeRouter {
    func presentFullScreenWebView(url: URL) {
        fullScreenWebViewURL = url
    }

    func dismissFullScreenWebView() {
        fullScreenWebViewURL = nil
    }
}


