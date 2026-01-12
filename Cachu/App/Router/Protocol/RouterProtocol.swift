import SwiftUI

// MARK: - Router Protocol
/// 앱 레벨 Router의 기본 인터페이스
/// NavigationPath 관리 및 화면 전환 책임
@MainActor
protocol RouterProtocol: AnyObject, Observable {
    associatedtype Route: Hashable

    var path: NavigationPath { get set }

    /// 새 화면을 네비게이션 스택에 추가
    func push(_ route: Route)

    /// 현재 화면을 스택에서 제거
    func pop()

    /// 루트 화면으로 이동 (스택 초기화)
    func popToRoot()
}

// MARK: - Default Implementation
extension RouterProtocol {
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

// MARK: - View Building Protocol
/// Router가 Route에 해당하는 View를 생성하는 책임
@MainActor
protocol ViewBuildable {
    associatedtype Route: Hashable
    associatedtype DestinationView: View

    /// Route에 해당하는 View 생성
    @ViewBuilder func buildView(for route: Route) -> DestinationView
}
