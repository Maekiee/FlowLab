import SwiftUI

// MARK: - SignUpView
/// 회원가입 화면
/// Navigation은 Store에서 Router를 통해 직접 처리
struct SignUpView: View {
    @State var store: SignUpStore
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 앱 로고/타이틀
                Text("Cachu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                // 입력 필드
                VStack(spacing: 12) {
                    InputField(
                        title: "이메일",
                        text: Binding(
                            get: { store.state.email },
                            set: { store.action(.updateEmail($0)) }
                        ),
                        keyboardType: .emailAddress
                    )

                    InputField(
                        title: "비밀번호",
                        text: Binding(
                            get: { store.state.password },
                            set: { store.action(.updatePassword($0)) }
                        ),
                        isSecure: true
                    )

                    InputField(
                        title: "닉네임",
                        text: Binding(
                            get: { store.state.nickname },
                            set: { store.action(.updateNickname($0)) }
                        )
                    )

                    InputField(
                        title: "전화번호",
                        text: Binding(
                            get: { store.state.phoneNumber },
                            set: { store.action(.updatePhoneNumber($0)) }
                        ),
                        keyboardType: .phonePad
                    )

                    InputField(
                        title: "소개글",
                        text: Binding(
                            get: { store.state.introduce },
                            set: { store.action(.updateIntroduce($0)) }
                        )
                    )
                }

                // 회원가입 버튼
                Button {
                    store.action(.tapSignUpButton)
                } label: {
                    if store.state.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text("회원가입")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .background(buttonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(store.state.isLoading || !store.state.isValid)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .errorAlert(message: $errorMessage)
        .onReceive(store.effect) { effect in
            handleSideEffect(effect)
        }
    }

    private var buttonBackgroundColor: Color {
        if store.state.isLoading || !store.state.isValid {
            return .gray
        }
        return .blue
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

// MARK: - InputField Component
private struct InputField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

