import SwiftUI

// MARK: - MainTabView
/// 메인 탭 뷰 (3개 탭: Home, Some, Profile)
/// 각 탭은 독립적인 NavigationStack과 Router를 가짐
struct MainTabView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DIContainer.self) private var container

    var body: some View {
        @Bindable var appRouter = router

        TabView(selection: $appRouter.selectedTab) {
            // MARK: - Home Tab
            container.makeHomeTabView()
                .environment(router.homeRouter)
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.icon)
                }
                .tag(MainTab.home)

            // MARK: - Some Tab
            container.makeVideoTabView()
                .environment(router.videoRouter)
                .tabItem {
                    Label(MainTab.video.title, systemImage: MainTab.video.icon)
                }
                .tag(MainTab.video)

            // MARK: - Profile Tab
            container.makeProfileTabView()
                .environment(router)
                .environment(router.profileRouter)
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
        }
    }
}
