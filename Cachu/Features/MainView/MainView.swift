import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("Main View")
            
            Button {
                Task {
                    do {
                        let toekn = await KeychainManager().readToken(service: AppConfig.bundleID, account: "accessToken")
                        let refreshToken = await KeychainManager().readToken(service: AppConfig.bundleID, account: "refreshToken")
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
