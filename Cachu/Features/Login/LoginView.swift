import SwiftUI

// MARK: - LoginView
/// 로그인 화면
/// Navigation은 Store에서 Router를 통해 직접 처리
struct LoginView: View {
    @State var store: LoginStore
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 앱 로고/타이틀
            Text("Cachu")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            // 입력 필드
            VStack(spacing: 12) {
                TextField("이메일", text: Binding(
                    get: { store.state.email },
                    set: { store.action(.inputEmail($0)) }
                ))
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                SecureField("비밀번호", text: Binding(
                    get: { store.state.password },
                    set: { store.action(.inputPassword($0)) }
                ))
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            // 로그인 버튼
            Button {
                store.action(.tapLogin)
            } label: {
                if store.state.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    Text("로그인")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(store.state.isLoading ? Color.gray : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(store.state.isLoading)

            Spacer()
        }
        .padding(.horizontal, 24)
        .navigationTitle("로그인")
        .navigationBarTitleDisplayMode(.inline)
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

