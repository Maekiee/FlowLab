import SwiftUI

// MARK: - ProfileTabView
/// 프로필 탭의 메인 콘텐츠 뷰
/// NavigationStack은 MainTabView의 ProfileTab에서 관리
struct ProfileTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(ProfileRouter.self) private var router

    var body: some View {
        List {
            // 프로필 섹션
            Section {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("사용자 이름")
                            .font(.headline)
                        Text("user@email.com")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        router.push(.editProfile)
                    } label: {
                        Text("편집")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 8)
            }

            // 앱 설정 섹션
            Section("앱 설정") {
                Button {
                    router.push(.settings)
                } label: {
                    Label("설정", systemImage: "gearshape")
                }
                .foregroundStyle(.primary)
            }

            // 로그아웃 섹션
            Section {
                Button(role: .destructive) {
                    appRouter.handleSessionExpired()
                } label: {
                    Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .navigationTitle("내 정보")
    }
}
