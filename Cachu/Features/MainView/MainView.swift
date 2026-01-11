import SwiftUI

struct MainView: View {
    @Environment(AppCoordinator.self) private var appCoordinator

    var body: some View {
        @Bindable var coordinator = appCoordinator

        TabView(selection: $coordinator.selectedTab) {
            // MARK: - Home Tab
            HomeTabView()
                .environment(coordinator.homeCoordinator)
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.icon)
                }
                .tag(MainTab.home)

            // MARK: - Map Tab
            MapTab(coordinator: coordinator.mapCoordinator)
                .tabItem {
                    Label(MainTab.map.title, systemImage: MainTab.map.icon)
                }
                .tag(MainTab.map)

            // MARK: - Favorite Tab
            FavoriteTab(coordinator: coordinator.favoriteCoordinator)
                .tabItem {
                    Label(MainTab.favorite.title, systemImage: MainTab.favorite.icon)
                }
                .tag(MainTab.favorite)

            // MARK: - Profile Tab
            ProfileTab(coordinator: coordinator.profileCoordinator)
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
        }
    }
}

// MARK: - Map Tab
struct MapTab: View {
    @Bindable var coordinator: MapCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            MapTabView(coordinator: coordinator)
                .navigationDestination(for: MapRoute.self) { route in
                    switch route {
                    case .propertyDetail(let id):
                        Text("매물 상세: \(id)")
                    case .filter:
                        Text("필터")
                    case .search:
                        Text("검색")
                    }
                }
        }
    }
}

// MARK: - Favorite Tab
struct FavoriteTab: View {
    @Bindable var coordinator: FavoriteCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            FavoriteTabView(coordinator: coordinator)
                .navigationDestination(for: FavoriteRoute.self) { route in
                    switch route {
                    case .propertyDetail(let id):
                        Text("매물 상세: \(id)")
                    }
                }
        }
    }
}

// MARK: - Profile Tab
struct ProfileTab: View {
    @Bindable var coordinator: ProfileCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProfileTabView(coordinator: coordinator)
                .navigationDestination(for: ProfileRoute.self) { route in
                    switch route {
                    case .settings:
                        Text("설정")
                    case .editProfile:
                        Text("프로필 수정")
                    case .myProperties:
                        Text("내 매물 관리")
                    }
                }
        }
    }
}
