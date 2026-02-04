import SwiftUI

struct Friend: Identifiable {
    let id: String
    let userId: String
    let nick: String
    let thumbnail: String?

    init(userId: String, nick: String, thumbnail: String? = nil) {
        self.id = userId
        self.userId = userId
        self.nick = nick
        self.thumbnail = thumbnail
    }
}

extension Friend {
    static let mockData: [Friend] = [
        Friend(userId: "69402d006648c4142c28cbb0", nick: "쿠키", thumbnail: ""),
        Friend(userId: "6950fcfca18bc2cef1ba3d9f", nick: "쿠키4"),
        Friend(userId: "6950fd51a18bc2cef1ba3da8", nick: "쿠키5", thumbnail: ""),
        Friend(userId: "694bf89da18bc2cef1ba36cb", nick: "쿠키공인중개사"),
        Friend(userId: "6953dca9a18bc2cef1ba4b93", nick: "쿠키뉴이열", thumbnail: ""),
        Friend(userId: "694b277ea18bc2cef1ba3621", nick: "친절한도원공인중개사"),
        Friend(userId: "user007", nick: "강지민", thumbnail: "")
    ]
}

struct FriendListView: View {
    @Environment(\.dismiss) private var dismiss
    @State var store: FriendListStore

    init(store: FriendListStore) {
        self._store = State(initialValue: store)
    }

    var body: some View {
        NavigationStack {
            List(Friend.mockData) { friend in
                Button {
                    // TODO: 친구 선택 이벤트 처리
                    print("선택된 친구: \(friend.nick)")
                } label: {
                    FriendRow(friend: friend)
                }
            }
            .listStyle(.plain)
            .navigationTitle("친구 목록")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

private struct FriendRow: View {
    let friend: Friend

    var body: some View {
        HStack(spacing: 12) {
            if let thumbnail = friend.thumbnail, !thumbnail.isEmpty {
                AsyncImage(url: URL(string: thumbnail)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray)
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.gray)
            }

            Text(friend.nick)
                .foregroundStyle(.primary)

            Spacer()
        }
        .contentShape(Rectangle())
    }
}

//#Preview {
//    FriendListView()
//}
