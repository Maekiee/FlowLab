
import SwiftUI

struct StartAuthView: View {
    @Environment(AppCoordinator.self) var coordinator
    
    var body: some View {
        VStack {
            
            Button {
                print("카카오 로그인")
            } label: {
                Text("카카오 로그인")
            }
            
            Button {
                print("애플 로그인")
            } label: {
                Text("애플 로그인")
            }
            
            Button {
                coordinator.present(fullScreen: .emailLogin)
//                coordinator.present(sheet: .emailLogin)
            } label: {
                Text("이메일 로그인")
            }
            
            Button {
                coordinator.push(.signup)
            } label: {
                Text("회원 가입")
            }
            
            
        }
    }
}

#Preview {
    StartAuthView()
}
