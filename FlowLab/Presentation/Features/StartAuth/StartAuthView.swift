import SwiftUI

struct StartAuthView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("FlowLab")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            // 로그인 버튼 영역
            VStack(spacing: 12) {
                Button {
                    print("카카오 로그인")
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("카카오로 시작하기")
                            .dsFont(.title1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                }

                Button {
                    print("애플 로그인")
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                        Text("Apple로 시작하기")
                            .dsFont(.title1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }

                Button {
                    router.pushAuth(.login)
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("이메일로 로그인")
                            .dsFont(.title1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.deepCream)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
            }

            // 회원가입 링크
            HStack {
                Text("계정이 없으신가요?")
                    .foregroundStyle(.secondary)
                
                Button {
                    router.pushAuth(.signUp)
                } label: {
                    Text("회원가입")
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 8)

            Spacer()
                .frame(height: 40)
        }
        .padding(.horizontal, 24)
        .navigationTitle("시작하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}
