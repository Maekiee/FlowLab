import Foundation
import SwiftUI
import Observation


enum AppRoute: Hashable {
    case login
    case signup
    case main
}

protocol CoordinatorProtocol {
    func push(_ route: AppRoute)
    func pop()
}


@MainActor
protocol AppViewFactory {
    func makeLoginView() -> AnyView
    func makeSignUpView() -> AnyView
    func makeMainView() -> AnyView
}

@MainActor
@Observable
final class Coordinator: CoordinatorProtocol {
    private let factory: AppViewFactory
    var navigationPath = NavigationPath()
    var rootRoute: AppRoute = .login
    
    init(factory: AppViewFactory) {
        self.factory = factory
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .login:
            factory.makeLoginView()
        case .signup:
            factory.makeSignUpView()
        case .main:
            factory.makeMainView()
        }
    }
    
    func push(_ route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func setRoot(_ route: AppRoute) {
        navigationPath = NavigationPath()
        rootRoute = route
    }
    
    
}
