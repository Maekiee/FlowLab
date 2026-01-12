import SwiftUI

// MARK: - MainTabView
/// 메인 탭 뷰 (3개 탭: Home, Some, Profile)
/// 각 탭은 독립적인 NavigationStack과 Router를 가짐
struct MainTabView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var appRouter = router

        TabView(selection: $appRouter.selectedTab) {
            // MARK: - Home Tab
            HomeTab()
                .environment(router.homeRouter)
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.icon)
                }
                .tag(MainTab.home)

            // MARK: - Some Tab
            SomeTab()
                .environment(router.someRouter)
                .tabItem {
                    Label(MainTab.some.title, systemImage: MainTab.some.icon)
                }
                .tag(MainTab.some)

            // MARK: - Profile Tab
            ProfileTabView()
                .environment(router)
                .environment(router.profileRouter)
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
        }
    }
}

// MARK: - Home Tab Container
/// 홈 탭의 NavigationStack 컨테이너
struct HomeTab: View {
    @Environment(HomeRouter.self) private var router

    var body: some View {
        @Bindable var homeRouter = router

        NavigationStack(path: $homeRouter.path) {
            HomeTabView()
                .environment(router)
                .navigationDestination(for: HomeRoute.self) { route in
                    router.buildView(for: route)
                }
        }
    }
}

// MARK: - Some Tab Container
/// Some 탭의 NavigationStack 컨테이너
struct SomeTab: View {
    @Environment(SomeRouter.self) private var router

    var body: some View {
        @Bindable var someRouter = router

        NavigationStack(path: $someRouter.path) {
            SomeTabView()
                .environment(router)
                .navigationDestination(for: SomeRoute.self) { route in
                    router.buildView(for: route)
                }
        }
    }
}

