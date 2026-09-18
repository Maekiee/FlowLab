import SwiftUI

@main
struct FlowLabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var container: DIContainer
    @State private var router: AppRouter

    init() {
        let container = DIContainer()
        _container = State(initialValue: container)
        _router = State(initialValue: container.makeAppRouter())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if router.isCheckingAuth {
                    ZStack {
                        Color(.systemBackground)
                            .ignoresSafeArea()

                        ProgressView()
                            .scaleEffect(1.2)
                    }
                } else {
                    switch router.rootView {
                    case .auth:
                        AuthFlowView()
                            .environment(router)
                            .environment(container)
                    case .main:
                        MainTabView()
                            .environment(router)
                            .environment(container)
                    }
                }
            }
            .task {
                await router.checkAutoLogin()
            }
        }
    }
}
