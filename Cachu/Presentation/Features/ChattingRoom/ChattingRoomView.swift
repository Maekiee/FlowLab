import SwiftUI

struct ChattingRoomView: View {
    @State var store: ChattingRoomStore
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = ChatMessage.mockMessages
    
    init(store: ChattingRoomStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 메시지 리스트
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onChange(of: messages.count) { _, _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
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
                        set: { store.action(.inputText($0)) },
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
                Text("김철수")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            store.action(.onAppear)
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }

        let newMessage = ChatMessage(
            id: UUID().uuidString,
            content: messageText,
            timestamp: Date(),
            isFromMe: true,
            senderProfileImage: nil
        )
        messages.append(newMessage)
        messageText = ""
    }
}

// MARK: - 메시지 버블 뷰
struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromMe {
                Spacer(minLength: 60)

                // 시간
                Text(message.formattedTime)
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
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 18))
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
                Text(message.formattedTime)
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)

                Spacer(minLength: 60)
            }
        }
    }
}

// MARK: - 채팅 메시지 모델
struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let timestamp: Date
    let isFromMe: Bool
    let senderProfileImage: String?

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: timestamp)
    }

    static let mockMessages: [ChatMessage] = [
        ChatMessage(
            id: "1",
            content: "안녕하세요! 혹시 물건 아직 있나요?",
            timestamp: Calendar.current.date(byAdding: .minute, value: -30, to: Date())!,
            isFromMe: false,
            senderProfileImage: nil
        ),
        ChatMessage(
            id: "2",
            content: "네 아직 있어요!",
            timestamp: Calendar.current.date(byAdding: .minute, value: -28, to: Date())!,
            isFromMe: true,
            senderProfileImage: nil
        ),
        ChatMessage(
            id: "3",
            content: "직거래 가능하신가요?",
            timestamp: Calendar.current.date(byAdding: .minute, value: -25, to: Date())!,
            isFromMe: false,
            senderProfileImage: nil
        ),
        ChatMessage(
            id: "4",
            content: "네 직거래 가능합니다. 강남역 근처로 오실 수 있으신가요?",
            timestamp: Calendar.current.date(byAdding: .minute, value: -20, to: Date())!,
            isFromMe: true,
            senderProfileImage: nil
        ),
        ChatMessage(
            id: "5",
            content: "좋아요! 내일 오후 3시에 가능할까요?",
            timestamp: Calendar.current.date(byAdding: .minute, value: -15, to: Date())!,
            isFromMe: false,
            senderProfileImage: nil
        ),
        ChatMessage(
            id: "6",
            content: "네 좋습니다 👍",
            timestamp: Calendar.current.date(byAdding: .minute, value: -10, to: Date())!,
            isFromMe: true,
            senderProfileImage: nil
        )
    ]
}

//#Preview {
//    NavigationStack {
//        ChattingRoomView(roomId: "preview-room-id")
//    }
//}
