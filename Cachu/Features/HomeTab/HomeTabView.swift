import SwiftUI
import Combine

// MARK: - HomeTabView (NavigationStack + Store + UI 통합)
struct HomeTabView: View {
    @State private var store = HomeStore()
    @Environment(HomeCoordinator.self) private var tabCoordinator

    var body: some View {
        @Bindable var coordinator = tabCoordinator
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .propertyDetail(let id):
                        Text("매물 상세: \(id)")
                    case .propertyList:
                        Text("매물 목록")
                    case .notification:
                        Text("알림")
                    }
                }
        }
        .environment(coordinator)  // 하위 View들에 주입
        .onReceive(store.effect) { sideEffect in
            handleSideEffect(sideEffect)
        }
    }

    // MARK: - Content
    private var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                if store.state.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    Text("홈 화면")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // 매물 목록 버튼
                    Button {
                        store.action(.tapPropertyList)
                    } label: {
                        HStack {
                            Image(systemName: "building.2")
                            Text("매물 목록 보기")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }

                    // 알림 버튼
                    Button {
                        store.action(.tapNotification)
                    } label: {
                        HStack {
                            Image(systemName: "bell")
                            Text("알림")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                    }

                    // 매물 리스트
                    ForEach(store.state.properties, id: \.self) { propertyId in
                        Button {
                            store.action(.tapPropertyDetail(id: propertyId))
                        } label: {
                            HStack {
                                Image(systemName: "house")
                                Text("매물: \(propertyId)")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("홈")
        .refreshable {
            store.action(.refresh)
        }
        .onAppear {
            store.action(.onAppear)
        }
    }

    // MARK: - SideEffect Handler
    private func handleSideEffect(_ effect: HomeStore.SideEffect) {
        switch effect {
        case .navigateToPropertyList:
            tabCoordinator.push(.propertyList)
        case .navigateToPropertyDetail(let id):
            tabCoordinator.push(.propertyDetail(id: id))
        case .navigateToNotification:
            tabCoordinator.push(.notification)
        }
    }
}
