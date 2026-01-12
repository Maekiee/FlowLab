import SwiftUI

// MARK: - ProfileTab
/// 프로필 탭의 메인 뷰
/// NavigationStack과 내부 콘텐츠(List)를 통합하여 관리
struct ProfileTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(ProfileRouter.self) private var router
    
    // Store 초기화
    // ProfileTabStore가 init()을 가지고 있다고 가정합니다.
    @State private var store = ProfileTabStore()

    var body: some View {
        @Bindable var profileRouter = router

        NavigationStack(path: $profileRouter.path) {
            List {
                // MARK: - 프로필 섹션
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

                // MARK: - 앱 설정 섹션
                Section("앱 설정") {
                    Button {
                        router.push(.settings)
                    } label: {
                        Label("설정", systemImage: "gearshape")
                    }
                    .foregroundStyle(.primary)
                }

                // MARK: - 로그아웃 섹션
                Section {
                    Button(role: .destructive) {
                        store.action(.tapLogout)
                    } label: {
                        Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("내 정보")
            // Router를 통한 화면 전환 처리
            .navigationDestination(for: ProfileRoute.self) { route in
                router.buildView(for: route)
            }
        }
    }
}
