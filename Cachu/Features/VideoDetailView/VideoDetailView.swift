import SwiftUI

struct VideoDetailView: View {
    
    @State var store: VideoDetailStore
    
    init(store: VideoDetailStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        VStack {
            if store.state.isLoading {
                ProgressView()
            } else {
                Text("Video Detail View")
                    .font(.title)
                Text("Video ID: \(store.state.videoId)")
                    .font(.headline)
            }
        }
        .onAppear {
            store.action(.onAppear)
        }
    }
}