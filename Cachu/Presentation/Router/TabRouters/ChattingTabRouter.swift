import SwiftUI

enum ChattingTabRoute: Hashable {
    case chattingRoom
}

@MainActor @Observable
final class ChattingTabRouter: TabRouterProtocol {
    typealias Route = ChattingTabRoute
    
    var path = NavigationPath()
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}

extension ChattingTabRouter {
    @ViewBuilder
    func buildView(for route: ChattingTabRoute) -> some View {
        switch route {
        case .chattingRoom:
            return Text("hello llll")
        default:
            Text("")
        }
    }
}
