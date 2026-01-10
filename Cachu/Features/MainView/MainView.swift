import SwiftUI

struct MainView: View {
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("Main View")

            Button {
                Task {
                    let token = await KeychainService().readToken(service: AppConfig.bundleID, account: AppConfig.accessTokenKey)
                    let refreshToken = await KeychainService().readToken(service: AppConfig.bundleID, account: AppConfig.refreshTokenKey)
                    print("Access Token: \(token ?? "nil")")
                    print("Refresh Token: \(refreshToken ?? "nil")")
                }
            } label: {
                Text("토큰 테스트")
            }

            Button(role: .destructive) {
                print("로그아웃")
//                Task {
//                    await coordinator.logout()
//                }
            } label: {
                Text("로그아웃")
            }
        }
    }
}

//#Preview {
//    MainView()
//        .environment(Coordinator(factory: DIContainer(), tokenManager: TokenManager()))
//}
