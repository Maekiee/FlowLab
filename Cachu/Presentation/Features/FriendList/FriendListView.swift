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
        Friend(userId: "user001", nick: "김철수", thumbnail: ""),
        Friend(userId: "user002", nick: "이영희"),
        Friend(userId: "user003", nick: "박민수", thumbnail: ""),
        Friend(userId: "user004", nick: "정수진"),
        Friend(userId: "user005", nick: "최동욱", thumbnail: ""),
        Friend(userId: "user006", nick: "홍길동"),
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
