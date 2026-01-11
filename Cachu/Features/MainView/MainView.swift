import SwiftUI

struct MainView: View {
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        @Bindable var coordinator = coordinator

        TabView(selection: $coordinator.selectedTab) {
            // MARK: - Home Tab
            HomeTab(coordinator: coordinator.homeCoordinator)
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

// MARK: - Home Tab
struct HomeTab: View {
    @Bindable var coordinator: HomeCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeTabView(coordinator: coordinator)
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .propertyDetail(let id):
                        PropertyDetailView(propertyId: id)
                    case .propertyList:
                        PropertyListView()
                    case .notification:
                        NotificationView()
                    }
                }
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
                        PropertyDetailView(propertyId: id)
                    case .filter:
                        FilterView()
                    case .search:
                        SearchView()
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
                        PropertyDetailView(propertyId: id)
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
                        SettingsView()
                    case .editProfile:
                        EditProfileView()
                    case .myProperties:
                        MyPropertiesView()
                    }
                }
        }
    }
}
