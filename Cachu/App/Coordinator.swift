import Foundation
import SwiftUI
import Observation


enum AppRoute: Hashable {
    case startAuth
    case login
    case signup
    case main
}

enum SheetRoute: Hashable {
    case emailLogin
}

protocol CoordinatorProtocol {
    func push(_ route: AppRoute)
    func pop()
    func setRoot(_ route: AppRoute)
    func present(sheet: SheetRoute)
}


@MainActor
protocol AppViewFactory {
    func makeStartAuthView() -> AnyView
    func makeLoginView() -> AnyView
    func makeSignUpView() -> AnyView
    func makeMainView() -> AnyView
}

@MainActor
@Observable
final class Coordinator: CoordinatorProtocol {
    private let factory: AppViewFactory
    
    var navigationPath = NavigationPath()
    var rootRoute: AppRoute = .startAuth
    var sheeRoute: SheetRoute?
    
    
    init(factory: AppViewFactory) {
        self.factory = factory
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .startAuth:
            factory.makeStartAuthView()
        case .login:
            factory.makeLoginView()
        case .signup:
            factory.makeSignUpView()
        case .main:
            factory.makeMainView()
        }
    }
    
    @ViewBuilder
    func buildSheet(route: SheetRoute) -> some View {
        switch route {
        case .emailLogin:
            factory.makeLoginView()
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
    
    func present(sheet: SheetRoute) {
        
    }
    
    
}
