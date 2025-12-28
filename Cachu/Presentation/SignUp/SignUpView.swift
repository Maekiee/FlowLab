
import SwiftUI

struct SignUpView: View {
    @State var store: SignUpStore
    @Environment(Coordinator.self) var coordinator
    
    var body: some View {
        VStack {
            TextField("이메일", text: Binding(
                get: { store.state.email},
                set: { store.dispatch(.updateEmail($0)) }
            ))
            
            SecureField("비밀번호", text: Binding(
                get: { store.state.password },
                set: { store.dispatch(.updatePassword($0)) }
            ))
            
            TextField("닉네임", text: Binding(
                get: { store.state.nickname },
                set: { store.dispatch(.updateNickname($0)) }
            ))
            
            TextField("폰번호", text: Binding(
                get: { store.state.phoneNumber },
                set: { store.dispatch(.updatePhoneNumber($0)) }
            ))
            
            TextField("소개글", text: Binding(
                get: { store.state.introduce },
                set: { store.dispatch(.updateIntroduce($0)) }
            ))
            
            Button {
                store.dispatch(.tapSignUpButton)
            } label: {
                Text("버튼 버튼")
            }

        }
    }
}

