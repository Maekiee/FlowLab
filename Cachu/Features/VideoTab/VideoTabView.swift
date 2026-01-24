import SwiftUI

struct VideoTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(VideoTabRouter.self) private var tabRouter
    
    @State var store: VideoTabStroe
    
    init(store: VideoTabStroe) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        @Bindable var videoTabRouter = tabRouter
        
        NavigationStack(path: $videoTabRouter.path) {
            VStack(spacing: 20) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
                
                Text("비디오 탭")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("추후 기능이 추가될 예정입니다")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("비디오")
        .navigationDestination(for: VideoTabRoute.self) { route in
            tabRouter.buildView(for: route)
        }
        .onAppear {
            print("호출 호출")
            store.action(.onAppear)
        }
    }
}

//#Preview {
//    VideoTabView()
//}
