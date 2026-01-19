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
                VStack(spacing: 0) {
                    ZStack {
                        VStack {
                            Text("배경 사진")
                        }
                        .frame(width: 400, height: 300)
                        .background(.deepCream)
                        
                        searchBar
                            .padding(.vertical, 12)
                         
                    }
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
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18, weight: .medium))

            TextField("검색어를 입력해주세요.", text: Binding(
                get: { store.state.searchInput },
                set: { store.action(.searchInput($0)) }
            ))
            .font(.system(size: 16))
            .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        .background(.white)
        .clipShape(Capsule())
        .padding(.horizontal, 16)
    }
}

#if DEBUG
#Preview {
    PreviewWrapper { preview in
        HomeTabView(store: preview.makeHomeTabStore())
    }
}
#endif

