import SwiftUI

@main
struct CachuApp: App {
    @State private var coordinator: AppCoordinator

    init() {
        let container = DIContainer()
        _coordinator = State(initialValue: AppCoordinator(
            factory: container,
            tokenManager: container.tokenManager
        ))
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            @Bindable var bindableCoordinator = coordinator

            Group {
                if coordinator.isCheckingAuth {
                    ProgressView()
                } else {
                    switch coordinator.rootRoute {
                    case .main:
                        coordinator.build(route: .main)
                    case .startAuth, .signup:
                        NavigationStack(path: $bindableCoordinator.navigationPath) {
                            coordinator.build(route: coordinator.rootRoute)
                                .navigationDestination(for: AppRoute.self) { route in
                                    coordinator.build(route: route)
                                }
                        }
                    }
                }
            }
            .sheet(item: $bindableCoordinator.sheetRoute) { route in
                coordinator.buildSheet(route: route)
            }
            .fullScreenCover(item: $bindableCoordinator.fullScreenSheetRoute) { route in
                coordinator.buildFullScreenSheet(route: route)
            }
            .task {
                await coordinator.checkAutoLogin()
            }
            .environment(coordinator)
        }
    }
}
