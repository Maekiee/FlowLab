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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    EstateDetailView()
//}
