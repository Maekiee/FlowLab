import SwiftUI

struct FriendListView: View {
    @State var store: FriendListStore
    
    init(store: FriendListStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        Text("Friend List")
    }
}

//#Preview {
//    FriendListView()
//}
