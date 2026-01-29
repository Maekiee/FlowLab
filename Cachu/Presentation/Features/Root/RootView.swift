import SwiftUI

// MARK: - RootView
/// 앱의 루트 뷰
/// AppRouter의 rootView 상태에 따라 AuthFlowView 또는 MainTabView를 표시
struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DIContainer.self) private var container

    var body: some View {
        Group {
            if router.isCheckingAuth {
                splashView
            } else {
                switch router.rootView {
                case .auth:
                    AuthFlowView()
                        .environment(router)
                        .environment(container)
                case .main:
                    MainTabView()
                        .environment(router)
                }
            }
        }
        .task {
            await router.checkAutoLogin()
        }
    }

    // MARK: - Splash View
    private var splashView: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ProgressView()
                .scaleEffect(1.2)
        }
    }
}
