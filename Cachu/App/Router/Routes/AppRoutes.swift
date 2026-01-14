import Foundation

// MARK: - App Root View
enum AppRootView: Equatable {
    case auth // 로그인 전
    case main // 로그인 후
}

// MARK: - Auth Routes
/// 인증 플로우 내 네비게이션
/// StartAuthView → Login/SignUp
enum AuthRoute: Hashable {
    case login
    case signUp
}

// MARK: - Sheet Routes
/// 바텀 시트로 표시되는 화면
enum SheetRoute: Identifiable, Hashable {
    case sample

    var id: String {
        switch self {
        case .sample:
            return "sample"
        }
    }
}

// MARK: - FullScreen Routes
/// 풀스크린으로 표시되는 화면
enum FullScreenRoute: Identifiable, Hashable {
    case sample

    var id: String {
        switch self {
        case .sample:
            return "sample"
        }
    }
}

// MARK: - Main Tab
/// 메인 탭 정의 (3개 탭)
enum MainTab: Int, Hashable, CaseIterable {
    case home = 0
    case some = 1
    case profile = 2

    var title: String {
        switch self {
        case .home:
            return "홈"
        case .some:
            return "탭2"
        case .profile:
            return "내 정보"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .some:
            return "square.grid.2x2"
        case .profile:
            return "person"
        }
    }
}

// MARK: - Home Tab Routes
/// 홈 탭 내 네비게이션
enum HomeRoute: Hashable {
    case propertyDetail(id: String)
    case propertyList
    case notification
}

// MARK: - Some Tab Routes
/// Some 탭 내 네비게이션 (추후 확장)
enum SomeRoute: Hashable {
    case detail(id: String)
}

// MARK: - Profile Tab Routes
/// 프로필 탭 내 네비게이션
enum ProfileRoute: Hashable {
    case settings
    case editProfile
}
