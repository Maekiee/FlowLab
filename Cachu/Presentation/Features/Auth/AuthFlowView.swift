import SwiftUI

// MARK: - AuthFlowView
/// 인증 플로우를 관리하는 컨테이너 뷰
/// StartAuthView → Login/SignUp 네비게이션 처리
struct AuthFlowView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DIContainer.self) private var container

    var body: some View {
        @Bindable var appRouter = router

        NavigationStack(path: $appRouter.authPath) {
            container.makeStartAuthView()
                .environment(router)
                .navigationDestination(for: AuthRoute.self) { route in
                    router.buildAuthView(for: route)
                }
        }
        .sheet(item: $appRouter.sheetRoute) { route in
            buildSheet(for: route)
        }
        .fullScreenCover(item: $appRouter.fullScreenRoute) { route in
            buildFullScreen(for: route)
        }
    }

    // MARK: - Sheet Builder
    @ViewBuilder
    private func buildSheet(for route: SheetRoute) -> some View {
        switch route {
        case .sample:
            Text("Sample Sheet")
        }
    }

    // MARK: - FullScreen Builder
    @ViewBuilder
    private func buildFullScreen(for route: FullScreenRoute) -> some View {
        switch route {
        case .sample:
            Text("Sample FullScreen")
        }
    }
}
