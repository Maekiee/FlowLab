import Foundation
import SwiftUI
import Observation


enum AppRoute: Hashable {
    case login
    case signup
}

protocol CoordinatorProtocol {
    func push(_ route: AppRoute)
    func pop()
}


@MainActor
protocol AppViewFactory {
    func makeLoginView() -> AnyView
    func makeSignUpView() -> AnyView
}

@MainActor
@Observable
final class Coordinator: CoordinatorProtocol {
    var navigationPath = NavigationPath()
    private let factory: AppViewFactory
    
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
            
        }
    }
    
    func push(_ route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
}
