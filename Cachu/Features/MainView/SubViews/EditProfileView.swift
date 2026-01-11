import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var nickname = ""
    @State private var phoneNumber = ""
    @State private var introduction = ""

    var body: some View {
        List {
            // 프로필 이미지
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }

                        Button("사진 변경") {
                            // 사진 선택
                        }
                        .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.vertical, 16)
            }

            // 기본 정보
            Section("기본 정보") {
                HStack {
                    Text("닉네임")
                        .frame(width: 80, alignment: .leading)
                    TextField("닉네임을 입력하세요", text: $nickname)
                }

                HStack {
                    Text("전화번호")
                        .frame(width: 80, alignment: .leading)
                    TextField("전화번호를 입력하세요", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
            }

            // 소개
            Section("소개") {
                TextEditor(text: $introduction)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("프로필 수정")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    // 저장 로직
                    dismiss()
                }
            }
        }
    }
}
