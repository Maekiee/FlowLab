import SwiftUI

struct FriendListView: View {
    @Environment(\.dismiss) private var dismiss
    @State var store: FriendListStore

    init(store: FriendListStore) {
        self._store = State(initialValue: store)
    }

    var body: some View {
        NavigationStack {
            Text("Friend List")
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

//#Preview {
//    FriendListView()
//}
