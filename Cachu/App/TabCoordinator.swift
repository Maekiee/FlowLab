import SwiftUI

// MARK: - Main Tab
enum MainTab: Hashable, CaseIterable {
    case home
    case map
    case favorite
    case profile

    var title: String {
        switch self {
        case .home: return "홈"
        case .map: return "지도"
        case .favorite: return "관심"
        case .profile: return "내 정보"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .map: return "map"
        case .favorite: return "heart"
        case .profile: return "person"
        }
    }
}

// MARK: - Tab Routes
enum HomeRoute: Hashable {
    case propertyDetail(id: String)
    case propertyList
    case notification
}

enum MapRoute: Hashable {
    case propertyDetail(id: String)
    case filter
    case search
}

enum FavoriteRoute: Hashable {
    case propertyDetail(id: String)
}

enum ProfileRoute: Hashable {
    case settings
    case editProfile
    case myProperties
}

// MARK: - Tab Coordinator Protocol
@MainActor
protocol TabCoordinatorProtocol: AnyObject, Observable {
    associatedtype Route: Hashable
    var path: NavigationPath { get set }

    func push(_ route: Route)
    func pop()
    func popToRoot()
}

extension TabCoordinatorProtocol {
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

// MARK: - Tab Coordinators
@MainActor
@Observable
final class HomeCoordinator: TabCoordinatorProtocol {
    typealias Route = HomeRoute
    var path = NavigationPath()
}

@MainActor
@Observable
final class MapCoordinator: TabCoordinatorProtocol {
    typealias Route = MapRoute
    var path = NavigationPath()
}

@MainActor
@Observable
final class FavoriteCoordinator: TabCoordinatorProtocol {
    typealias Route = FavoriteRoute
    var path = NavigationPath()
}

@MainActor
@Observable
final class ProfileCoordinator: TabCoordinatorProtocol {
    typealias Route = ProfileRoute
    var path = NavigationPath()
}
