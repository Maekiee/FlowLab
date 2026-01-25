import SwiftUI

struct VideoDetailView: View {
    
    @State var store: VideoDetailStore
    
    init(store: VideoDetailStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


