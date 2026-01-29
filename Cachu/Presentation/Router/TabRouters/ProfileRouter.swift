import SwiftUI

// MARK: - Profile Tab Routes
enum ProfileRoute: Hashable {
    case settings
    case editProfile
}


// MARK: - ProfileRouter
/// 프로필 탭의 독립적인 네비게이션을 관리하는 Router
@MainActor
@Observable
final class ProfileRouter: TabRouterProtocol {
    typealias Route = ProfileRoute

    // MARK: - Properties
    var path = NavigationPath()
    let container: DIContainer

    // MARK: - Initialization
    init(container: DIContainer) {
        self.container = container
    }

    // MARK: - View Building
    @ViewBuilder
    func buildView(for route: ProfileRoute) -> some View {
        switch route {
        case .settings:
            // TODO: SettingsView 구현 후 연결
            Text("Settings")
        case .editProfile:
            // TODO: EditProfileView 구현 후 연결
            Text("Edit Profile")
        }
    }
}
