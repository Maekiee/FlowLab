
import SwiftUI

struct SignUpView: View {
    @State var store: SignUpStore
    @Environment(Coordinator.self) var coordinator
    
    var body: some View {
        VStack {
            TextField("이메일", text: Binding(
                get: { store.state.email},
                set: { store.action(.updateEmail($0)) }
            ))
            
            SecureField("비밀번호", text: Binding(
                get: { store.state.password },
                set: { store.action(.updatePassword($0)) }
            ))
            
            TextField("닉네임", text: Binding(
                get: { store.state.nickname },
                set: { store.action(.updateNickname($0)) }
            ))
            
            TextField("폰번호", text: Binding(
                get: { store.state.phoneNumber },
                set: { store.action(.updatePhoneNumber($0)) }
            ))
            
            TextField("소개글", text: Binding(
                get: { store.state.introduce },
                set: { store.action(.updateIntroduce($0)) }
            ))
            
            Button {
                store.action(.tapSignUpButton)
            } label: {
                Text("버튼 버튼")
            }
        } // VStack
        .padding(20)
        .padding(.horizontal)
        .onReceive(store.effect) { effect in
            switch effect {
            case .navigateToMain:
                coordinator.setRoot(.main)
            case .navigateToLogin:
                print("로그인 화면으로")
            case .showToast(message: let message):
                print("토스트 메세지ㅏ")
            }
        }
    }
}

