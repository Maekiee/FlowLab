import SwiftUI

// MARK: - AuthFlowView
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
    }
}
