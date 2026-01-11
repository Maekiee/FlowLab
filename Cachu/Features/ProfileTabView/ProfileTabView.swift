import SwiftUI

struct ProfileTabView: View {
    @Environment(AppCoordinator.self) private var appCoordinator
    let coordinator: ProfileCoordinator

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
                        coordinator.push(.editProfile)
                    } label: {
                        Text("편집")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 8)
            }

            // 메뉴 섹션
            Section("내 활동") {
                Button {
                    coordinator.push(.myProperties)
                } label: {
                    Label("내 매물 관리", systemImage: "building.2")
                }
                .foregroundStyle(.primary)
            }

            Section("앱 설정") {
                Button {
                    coordinator.push(.settings)
                } label: {
                    Label("설정", systemImage: "gearshape")
                }
                .foregroundStyle(.primary)
            }

            // 로그아웃 섹션
            Section {
                Button(role: .destructive) {
                    appCoordinator.handleSessionExpired()
                } label: {
                    Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .navigationTitle("내 정보")
    }
}
