import SwiftUI

@main
struct CachuApp: App {
    let container = DIContainer()
    
    @State private var coordinator: Coordinator
    
    init() {
        let container = DIContainer()
        _coordinator = State(initialValue: Coordinator(factory: container))
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                coordinator.build(route: coordinator.rootRoute)
                    .navigationDestination(for: AppRoute.self) { route in
                        coordinator.build(route: route)
                    }
            }
            .environment(coordinator)
        }
    }
}
