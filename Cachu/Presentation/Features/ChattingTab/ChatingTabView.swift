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
                Text("Hello, World!")
            }
        }
        .navigationDestination(for: ChattingTabRoute.self) { route in
            tabRouter.buildView(for: route)
        }
        .onAppear {
            store.action(.onAppear)
        }
    }
}

//#Preview {
//    ChattingTabView()
//}
