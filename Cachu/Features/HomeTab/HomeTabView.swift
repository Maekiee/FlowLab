import SwiftUI
import Combine
import Kingfisher


struct MyImageDownloadRequestModifier: ImageDownloadRequestModifier {
    let accessToken: String

    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
        modifiedRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        modifiedRequest.setValue(AppConfig.SeSACKey, forHTTPHeaderField: "SeSACKey")
        return modifiedRequest
    }
}


// MARK: - Home Tab Container
struct HomeTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(HomeRouter.self) private var router
    
    @State var store: HomeTabStore
    @State private var errorMessage: String?
    @State private var webAlertMessage: String?
    
    init(store: HomeTabStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        @Bindable var homeRouter = router
        
        NavigationStack(path: $homeRouter.path) {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        TabView {
//                            ForEach(store.state.homeTabTopItems, id: \.self) { homeTopItem in
//                                ZStack {
//                                    KFImage(homeTopItem.thumbnail)
//                                        .requestModifier(MyImageDownloadRequestModifier(accessToken: store.state.accessToken ?? ""))
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(height: 300)
//                                    Text(homeTopItem.title)
//                                }
//                            }
                            
                            ForEach(store.state.mainBanners, id: \.self) { banner in
                                KFImage(URL(string: AppConfig.baseURL + banner.imageUrl))
                                    .requestModifier(MyImageDownloadRequestModifier(accessToken: store.state.accessToken ?? ""))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .onTapGesture {
                                        store.action(.didTapBanner(banner))
                                    }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(height: 300)
                        
//                        searchBar
//                            .padding(.vertical, 12)
                         
                    }
                }
                .onAppear() {
                    store.action(.onAppear)
                }
                .onReceive(store.effect) { effect in
                    switch effect {
                    case .showErrorAlert(let mesasge):
                        errorMessage = mesasge
                    case .routeTo(let route):
                        switch route {
                        case .webView(let url):
                            router.presentFullScreenWebView(url: url)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: Binding(
                get: { router.fullScreenWebViewURL != nil },
                set: { if !$0 { router.dismissFullScreenWebView() } }
            )) {
                if let url = router.fullScreenWebViewURL {
                    CommonWebView(
                        url: url,
                        accessToken: store.state.accessToken ?? ""
                    ) { count in
                        webAlertMessage = "출석 완료: \(count)회"
                    }
                    .alert("출석", isPresented: Binding(
                        get: { webAlertMessage != nil },
                        set: { if !$0 { webAlertMessage = nil } }
                    )) {
                        Button("확인") {
                            webAlertMessage = nil
                            router.dismissFullScreenWebView()
                        }
                    } message: {
                        if let message = webAlertMessage {
                            Text(message)
                        }
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

#Preview {
    PreviewWrapper { preview in
        HomeTabView(store: preview.makeHomeTabStore())
    }
}

