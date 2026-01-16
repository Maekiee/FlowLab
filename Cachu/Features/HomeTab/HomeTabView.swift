import SwiftUI
import Combine


// MARK: - Home Tab Container
/// 홈 탭의 NavigationStack 컨테이너
struct HomeTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(HomeRouter.self) private var router
    
    @State var store: HomeTabStore
    
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
                }
                .navigationTitle("홈")
                //            .refreshable {
                //                store.action(.refresh)
                //            }
                //            .onAppear {
                //                store.action(.onAppear)
                //            }
                
                //            HomeTabView()
                //                .environment(router)
                //                .navigationDestination(for: HomeRoute.self) { route in
                //                    router.buildView(for: route)
                //                }
            }
        }
    }
}

// MARK: - HomeTabView
/// 홈 탭의 메인 콘텐츠 뷰
/// NavigationStack은 MainTabView의 HomeTab에서 관리
//struct HomeTabView: View {
//    @Environment(AppRouter.self) private var appRouter
//    @Environment(HomeRouter.self) private var router
//    
//    
//
//    var body: some View {
//       
//            
//    }
//
//    // MARK: - SideEffect Handler
//    private func handleSideEffect(_ effect: HomeStore.SideEffect) {
//        switch effect {
//        case .navigateToPropertyList:
//            router.push(.propertyList)
//        case .navigateToPropertyDetail(let id):
//            router.push(.propertyDetail(id: id))
//        case .navigateToNotification:
//            router.push(.notification)
//        }
//    }
//}
