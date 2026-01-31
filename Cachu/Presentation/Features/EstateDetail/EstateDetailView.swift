import SwiftUI

struct EstateDetailView {
    @Environment(AppRouter.self) private var appRouter
    
    @State var store: EstateDetailStore
    
    init(store: EstateDetailStore) {
        self._store = State(initialValue: store)
    }
}

extension EstateDetailView: View {
    
    var body: some View {
        VStack {
            Text("Hello Detail")
        }.onAppear {
            store.action(.onAppear)
        }
    }
}

//#Preview {
//    EstateDetailView()
//}
