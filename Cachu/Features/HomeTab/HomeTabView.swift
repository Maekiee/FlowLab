import SwiftUI
import Combine

// MARK: - HomeTabView
/// 홈 탭의 메인 콘텐츠 뷰
/// NavigationStack은 MainTabView의 HomeTab에서 관리
struct HomeTabView: View {
    @State private var store = HomeStore()
    @Environment(HomeRouter.self) private var router

    var body: some View {
        content
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
            router.push(.propertyList)
        case .navigateToPropertyDetail(let id):
            router.push(.propertyDetail(id: id))
        case .navigateToNotification:
            router.push(.notification)
        }
    }
}
