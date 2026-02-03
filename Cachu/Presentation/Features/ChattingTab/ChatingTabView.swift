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
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationDestination(for: ChattingTabRoute.self) { route in
            tabRouter.buildView(for: route)
        }
    }
}

//#Preview {
//    ChattingTabView()
//}
