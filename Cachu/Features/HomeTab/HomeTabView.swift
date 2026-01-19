import SwiftUI
import Combine


// MARK: - Home Tab Container
struct HomeTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(HomeRouter.self) private var router
    
    @State var store: HomeTabStore
    @State private var errorMessage: String?
    
    init(store: HomeTabStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        @Bindable var homeRouter = router
        
        NavigationStack(path: $homeRouter.path) {
            ScrollView {
                VStack() {
                    ZStack {
                        searchBar
                    }.border(.deepCoast, width: 1)
                }
                .onAppear() {
                    store.action(.onAppear)
                }
                .onReceive(store.effect) { effect in
                    switch effect {
                    case .showErrorAlert(let mesasge):
                        errorMessage = mesasge
                    }
                }
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            Image("search")
                .foregroundColor(.gray60)
            
            TextField("검색어를 입력해 주세요", text: Binding(
                get: { store.state.searchInput },
                set: { store.action(.searchInput($0)) }
            ))
        }
        .frame(height: 40)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}

#if DEBUG
#Preview {
    PreviewWrapper { preview in
        HomeTabView(store: preview.makeHomeTabStore())
    }
}
#endif

