import SwiftUI

@main
struct CachuApp: App {
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
            RootView()
                .environment(router)
                .environment(container)
        }
    }
}
