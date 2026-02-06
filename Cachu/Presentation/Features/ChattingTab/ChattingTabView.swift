import SwiftUI

struct ChattingTabView: View {
    @Environment(ChattingTabRouter.self) private var chattingTabRouter
    @State var store: ChattingTabStore

    init(store: ChattingTabStore) {
        self._store = State(initialValue: store)
    }

    var body: some View {
        @Bindable var tabRouter = chattingTabRouter

        NavigationStack(path: $tabRouter.path) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.state.chatRooms, id: \.room_id) { room in
                        ChatRoomListCell(room: room)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.action(.onTapRoom(roomId: room.room_id))
                            }

                        Divider()
                            .padding(.leading, 76)
                    }
                }
            }
            .navigationDestination(for: ChattingTabRoute.self) { route in
                tabRouter.buildView(for: route)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        chattingTabRouter.fullScreenRoute = .friendList
                    } label: {
                        Image("list")
                    }
                }
            }
            .fullScreenCover(item: $tabRouter.fullScreenRoute, onDismiss: {
                chattingTabRouter.handlePendingNavigation()
            }) { route in
                tabRouter.buildFullScreenView(for: route)
            }
            .onReceive(store.effect) { effect in
                switch effect {
                case .showAlert(let message):
                    print("에러 메세지")
                case .routeTo(let route):
                    chattingTabRouter.push(route)
                }
            }
        }
        .onAppear {
            store.action(.onAppear)
        }
    }
}

// MARK: - 채팅방 리스트 셀
struct ChatRoomListCell: View {
    let room: ChatRoomEntity

    private var otherParticipant: UserInfoEntity? {
        room.participants.last
    }

    private var formattedTime: String {
        guard let lastChat = room.lastChat else { return "" }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: lastChat.createdAt) else { return "" }

        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "a h:mm"
            timeFormatter.locale = Locale(identifier: "ko_KR")
            return timeFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // 프로필 이미지
            Circle()
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 52, height: 52)
                .overlay {
                    if let profileImage = otherParticipant?.profileImage,
                       let url = URL(string: profileImage) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.gray)
                                .font(.system(size: 24))
                        }
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 24))
                    }
                }

            // 이름, 메시지
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(otherParticipant?.nick ?? "알 수 없음")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.black)

                    Spacer()

                    Text(formattedTime)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }

                Text(room.lastChat?.content ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

//#Preview {
//    ChattingTabView()
//}
