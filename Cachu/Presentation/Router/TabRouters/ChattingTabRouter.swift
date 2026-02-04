import SwiftUI

enum ChattingTabRoute: Hashable {
    case chattingRoom
}

enum ChattingTabFullScreenRoute:Identifiable {
    case friendList
    
    var id: Self { self }
}

@MainActor @Observable
final class ChattingTabRouter: TabRouterProtocol {
    typealias Route = ChattingTabRoute

    var path = NavigationPath()
    var fullScreenRoute: ChattingTabFullScreenRoute?

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
            container.makeChattingRoomView()
        }
    }

    @ViewBuilder
    func buildFullScreenView(for route: ChattingTabFullScreenRoute) -> some View {
        switch route {
        case .friendList:
            container.makeFriendListView()
        }
    }
}
