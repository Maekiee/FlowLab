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
                
                Button {
                    store.action(.onTapRoom(roomId: "test-room-id"))
                } label: {
                    Text("채팅방 이동")
                }

            }
            .navigationDestination(for: ChattingTabRoute.self) { route in
                tabRouter.buildView(for: route)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        chattingTabRouter.fullScreenRoute = .friendList
                    } label: {
                        Image("list")
                    }
                }
            }
            .fullScreenCover(item: $tabRouter.fullScreenRoute, onDismiss: {
                chattingTabRouter.handlePendingNavigation()
            }) { route in
                tabRouter.buildFullScreenView(for: route)
            }
            .onReceive(store.effect) { effect in
                switch effect {
                case .showAlert(let message):
                    print("에러 메세지")
                case .routeTo(let route):
                    chattingTabRouter.push(route)
                }
            }
        }
        .onAppear {
            store.action(.onAppear)
        }
    }
}

//#Preview {
//    ChattingTabView()
//}
