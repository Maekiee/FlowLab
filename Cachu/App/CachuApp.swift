import SwiftUI

@main
struct CachuApp: App {
    
    @State private var coordinator: Coordinator
    
    init() {
        let container = DIContainer()
        _coordinator = State(initialValue: Coordinator(factory: container))
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var body: some Scene {
        WindowGroup {
            @Bindable var bindableCoordinator = coordinator
            NavigationStack(path: $bindableCoordinator.navigationPath) {
                coordinator.build(route: coordinator.rootRoute)
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.build(route: route)
                    }
            }
            .sheet(item: $bindableCoordinator.sheeRoute) { route in
                coordinator.buildSheet(route: route)
            }
            .fullScreenCover(item: $bindableCoordinator.fullScreenSheetRoute){ route in
                coordinator.buildFullScreenSheet(route: route)
            }
            .environment(coordinator)
        }
    }
}
