import Foundation
import SwiftUI
import Observation


enum AppRoute: Hashable {
    case startAuth
    case signup
    case main
}

enum SheetRoute: Identifiable {
    case someView
    
    var id: String {
        switch self {
        case .someView: return "someView"
        }
    }
}

enum FullScreenSheetRoute: Identifiable {
    case emailLogin
    
    var id: String {
        switch self {
        case .emailLogin: return "emailLogin"
        }
    }
}

protocol CoordinatorProtocol {
    func push(_ route: AppRoute)
    func pop()
    func setRoot(_ route: AppRoute)
    
    func present(sheet: SheetRoute)
    func dismissSheet()
    
    func present(fullScreen: FullScreenSheetRoute)
    func dismissFullScreen()
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
    var sheetRoute: SheetRoute?
    var fullScreenSheetRoute: FullScreenSheetRoute?
    
    
    
    init(factory: AppViewFactory) {
        self.factory = factory
    }
    
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .startAuth:
            factory.makeStartAuthView()
        case .signup:
            factory.makeSignUpView()
        case .main:
            factory.makeMainView()
        }
    }
    
    @ViewBuilder
    func buildSheet(route: SheetRoute) -> some View {
        switch route {
        case .someView:
            Text("나중에 뷰 여기다가")
        }
    }
    
    @ViewBuilder
    func buildFullScreenSheet(route: FullScreenSheetRoute) -> some View {
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
        self.sheetRoute = sheet
    }
    
    func dismissSheet() {
        self.sheetRoute = nil
    }
    
    func present(fullScreen: FullScreenSheetRoute) {
        self.fullScreenSheetRoute = fullScreen
    }
    
    func dismissFullScreen() {
        self.fullScreenSheetRoute = nil
    }
    
    
}
