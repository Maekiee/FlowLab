import SwiftUI

struct ChattingRoomView: View {
    @State var store: ChattingRoomStore

    init(store: ChattingRoomStore) {
        self._store = State(initialValue: store)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 메시지 리스트
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(store.state.chatList, id: \.chatId) { message in
                            MessageBubbleView(
                                message: message,
                                isFromMe: store.isFromMe(message)
                            )
                            .id(message.chatId)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: store.state.chatList.count) { _, _ in
                    if let lastMessage = store.state.chatList.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.chatId, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // 하단 입력창
            HStack(spacing: 12) {
                // 플러스 버튼
                Button {
                    // 첨부 기능
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22))
                        .foregroundStyle(.gray)
                }

                // 텍스트 입력 필드
                HStack {
                    TextField("메시지를 입력하세요", text: Binding(
                        get: { store.state.chatText },
                        set: { store.action(.inputText($0)) }
                    ))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // 전송 버튼
                Button {
                    store.action(.sendChat)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(store.state.chatText.isEmpty ? .gray : .deepCoast)
                }
                .disabled(store.state.chatText.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.white)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("채팅")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            store.action(.onAppear)
        }
        .onDisappear {
            store.onDisappear()
        }
    }
}

// MARK: - 메시지 버블 뷰
struct MessageBubbleView: View {
    let message: ChatResponseEntity
    let isFromMe: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isFromMe {
                Spacer(minLength: 60)

                // 시간
                Text(formattedTime)
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)

                // 내 메시지 버블
                Text(message.content)
                    .dsFont(.body1)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.deepCream)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                // 상대방 프로필 이미지
                if let profileImage = message.sender.profileImage,
                   let url = URL(string: profileImage) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color(.systemGray4)
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color(.systemGray4))
                        .frame(width: 36, height: 36)
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.gray)
                                .font(.system(size: 18))
                        }
                }

                // 상대방 메시지 버블
                Text(message.content)
                    .dsFont(.body1)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.gray30)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                // 시간
                Text(formattedTime)
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)

                Spacer(minLength: 60)
            }
        }
    }

    private var formattedTime: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: message.createdAt) else { return "" }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "a h:mm"
        displayFormatter.locale = Locale(identifier: "ko_KR")
        return displayFormatter.string(from: date)
    }
}
