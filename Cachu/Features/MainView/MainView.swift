import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("Main View")
            
            Button {
                Task {
                    do {
                        let toekn = await KeychainService().readToken(service: AppConfig.bundleID, account: AppConfig.accessTokenKey)
                        let refreshToken = await KeychainService().readToken(service: AppConfig.bundleID, account: AppConfig.refreshTokenKey)
                    } catch {
                        
                    }
                }
            } label: {
                Text("토큰 테스트")
            }

        }
    }
}

#Preview {
    MainView()
}
