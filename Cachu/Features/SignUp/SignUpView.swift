import SwiftUI

// MARK: - SignUpView
/// 회원가입 화면
/// Navigation은 Store에서 Router를 통해 직접 처리
struct SignUpView: View {
    @State var store: SignUpStore
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("이메일", text: Binding(
                    get: { store.state.email },
                    set: { store.action(.updateEmail($0)) }
                ))
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

                SecureField("비밀번호", text: Binding(
                    get: { store.state.password },
                    set: { store.action(.updatePassword($0)) }
                ))

                TextField("닉네임", text: Binding(
                    get: { store.state.nickname },
                    set: { store.action(.updateNickname($0)) }
                ))

                TextField("전화번호", text: Binding(
                    get: { store.state.phoneNumber },
                    set: { store.action(.updatePhoneNumber($0)) }
                ))
                .keyboardType(.phonePad)

                TextField("소개글", text: Binding(
                    get: { store.state.introduce },
                    set: { store.action(.updateIntroduce($0)) }
                ))

                Button {
                    store.action(.tapSignUpButton)
                } label: {
                    if store.state.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("회원가입")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(store.state.isLoading || !store.state.isValid)
            }
            .padding()
        }
        .navigationTitle("회원가입")
        .errorAlert(message: $errorMessage)
        .onReceive(store.effect) { effect in
            handleSideEffect(effect)
        }
    }

    // MARK: - SideEffect Handler (UI 피드백만)
    private func handleSideEffect(_ effect: SignUpStore.SideEffect) {
        switch effect {
        case .showToast(let message):
            print("Toast: \(message)")
        case .showErrorAlert(let message):
            errorMessage = message
        }
    }
}

