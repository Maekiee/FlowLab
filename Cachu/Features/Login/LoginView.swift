import SwiftUI

struct LoginView: View {
    @State var store: LoginStore
    @State private var errorMessage: String?
    @Environment(Coordinator.self) var coordinator
    
    
    var body: some View {
        VStack {
            
            TextField("이메일", text: Binding(
                get: { store.state.email },
                set: { store.action(.inputEmail($0)) }
            ))
            .textInputAutocapitalization(.never)
            
            SecureField("비밀번호", text: Binding(
                get: { store.state.password },
                set: { store.action(.inputPassword($0)) }
            ))
            
            Button {
                store.action(.tapLogin)
            } label: {
                Text("로그인")
            }
            
        }
        .errorAlert(message: $errorMessage)
        .onReceive(store.effect) { effect in
            switch effect {
            case .navigateToMain:
                coordinator.dismissFullScreen()
                coordinator.setRoot(.main)
            case .showErrorAlert(let message):
                errorMessage = message
            }
        }
    }
}

