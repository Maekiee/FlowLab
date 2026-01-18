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
                VStack(spacing: 20) {
                    Text("홈 화면")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .background(.deepCream)
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
}

