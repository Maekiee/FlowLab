import SwiftUI

struct ChattingTabView: View {
    @State var store: ChattingTabStore
    
    init(store: ChattingTabStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    ChattingTabView()
//}
