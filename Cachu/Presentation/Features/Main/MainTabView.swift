import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    @Environment(DIContainer.self) private var container
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        @Bindable var appRouter = router
        
        TabView(selection: $appRouter.selectedTab) {
            container.makeHomeTabView(tabRouter: router.homeRouter)
                .environment(router.homeRouter)
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.icon)
                }
                .tag(MainTab.home)
            
            container.makeVideoTabView()
                .environment(router.videoRouter)
                .tabItem {
                    Label(MainTab.video.title, systemImage: MainTab.video.icon)
                }
                .tag(MainTab.video)
            
            container.makeProfileTabView()
                .environment(router)
                .environment(router.profileRouter)
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.icon)
                }
                .tag(MainTab.profile)
        }
        .fullScreenCover(item: $appRouter.fullScreenRoute) { route in
            switch route {
            case .payment(let totalPrice):
                PaymentView(
                    totalPrice: totalPrice,
                    onFinish: { _ in
                        router.dismissFullScreen()
                    },
                    onDismiss: {
                        router.dismissFullScreen()
                    }
                )
            }
        }
    }
}
