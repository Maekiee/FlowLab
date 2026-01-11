import SwiftUI

struct SettingsView: View {
    @State private var notificationEnabled = true
    @State private var darkModeEnabled = false

    var body: some View {
        List {
            Section("알림") {
                Toggle("푸시 알림", isOn: $notificationEnabled)
            }

            Section("화면") {
                Toggle("다크 모드", isOn: $darkModeEnabled)
            }

            Section("정보") {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }

                NavigationLink("이용약관") {
                    Text("이용약관 내용")
                        .navigationTitle("이용약관")
                }

                NavigationLink("개인정보 처리방침") {
                    Text("개인정보 처리방침 내용")
                        .navigationTitle("개인정보 처리방침")
                }
            }

            Section("계정") {
                Button("로그아웃", role: .destructive) {
                    // 로그아웃 처리
                }

                Button("회원탈퇴", role: .destructive) {
                    // 회원탈퇴 처리
                }
            }
        }
        .navigationTitle("설정")
    }
}
