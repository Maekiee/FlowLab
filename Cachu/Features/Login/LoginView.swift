import SwiftUI

// MARK: - LoginView
/// 로그인 화면
/// Navigation은 Store에서 Router를 통해 직접 처리
struct LoginView: View {
    @State var store: LoginStore
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            TextField("이메일", text: Binding(
                get: { store.state.email },
                set: { store.action(.inputEmail($0)) }
            ))
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)

            SecureField("비밀번호", text: Binding(
                get: { store.state.password },
                set: { store.action(.inputPassword($0)) }
            ))

            Button {
                store.action(.tapLogin)
            } label: {
                if store.state.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(store.state.isLoading)
        }
        .padding()
        .navigationTitle("로그인")
        .errorAlert(message: $errorMessage)
        .onReceive(store.effect) { effect in
            handleSideEffect(effect)
        }
    }

    // MARK: - SideEffect Handler (UI 피드백만)
    private func handleSideEffect(_ effect: LoginStore.SideEffect) {
        switch effect {
        case .showErrorAlert(let message):
            errorMessage = message
        }
    }
}

