import SwiftUI

// MARK: - SomeTabView
/// Some 탭의 메인 콘텐츠 뷰
/// 추후 기능 확장 시 구체화
struct SomeTabView: View {
    @Environment(SomeRouter.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("탭 2")
                .font(.title2)
                .fontWeight(.semibold)

            Text("추후 기능이 추가될 예정입니다")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("탭 2")
    }
}
