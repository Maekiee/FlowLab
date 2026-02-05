import SwiftUI

enum ChattingTabRoute: Hashable {
    case chattingRoom(roomId: String)
}

enum ChattingTabFullScreenRoute: Identifiable {
    case friendList

    var id: Self { self }
}

@MainActor @Observable
final class ChattingTabRouter: TabRouterProtocol {
    typealias Route = ChattingTabRoute

    var path = NavigationPath()
    var fullScreenRoute: ChattingTabFullScreenRoute?
    var pendingRoute: ChattingTabRoute?

    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func dismissFullScreenAndNavigate(to route: ChattingTabRoute) {
        pendingRoute = route
        fullScreenRoute = nil
    }

    func handlePendingNavigation() {
        guard let route = pendingRoute else { return }
        pendingRoute = nil
        push(route)
    }
}

extension ChattingTabRouter {

    @ViewBuilder
    func buildView(for route: ChattingTabRoute) -> some View {
        switch route {
        case .chattingRoom(let roomId):
            container.makeChattingRoomView(roomId: roomId)
        }
    }

    @ViewBuilder
    func buildFullScreenView(for route: ChattingTabFullScreenRoute) -> some View {
        switch route {
        case .friendList:
            container.makeFriendListView { [weak self] roomId in
                self?.dismissFullScreenAndNavigate(to: .chattingRoom(roomId: roomId))
            }
        }
    }
}
