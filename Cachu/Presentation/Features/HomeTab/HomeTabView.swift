import SwiftUI
import Combine
import Kingfisher


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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    GeometryReader { geometry in
                        ZStack(alignment: .top) {
                            topBannerSection
                                .frame(height: 335 + geometry.safeAreaInsets.top)
                                .clipped()

                            searchBar
                                .padding(.top, geometry.safeAreaInsets.top + 60)
                        }
                    }
                    .frame(height: 335)

                    VStack(spacing: 0) {
                        categorySection
                            .padding(.top, 20)

                        recentEstateSection
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)

                        subBannerSection
                            .padding(.top, 24)

                        hotEstateSection
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)

                        dailyTopicSection
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 24)
                            .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(.systemGroupedBackground))
            .onAppear {
                store.action(.onAppear)
            }
            .onReceive(store.effect) { effect in
                switch effect {
                case .showErrorAlert(let message):
                    errorMessage = message
                case .routeTo(let route):
                    switch route {
                    case .webView(let url):
                        router.presentFullScreenWebView(url: url)
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
}

// MARK: - Subviews
private extension HomeTabView {

    var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .font(.system(size: 16, weight: .medium))

            TextField("검색어를 입력해주세요.", text: Binding(
                get: { store.state.searchInput },
                set: { store.action(.searchInput($0)) }
            ))
            .font(.system(size: 15))
            .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    var topBannerSection: some View {
        TabView {
            ForEach(store.state.homeTabTopItems) { item in
                ZStack(alignment: .bottomLeading) {
                    KFImage(item.thumbnail)
                        .withHeaders()
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.6)],
                        startPoint: .center,
                        endPoint: .bottom
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)

                        Text(item.introduction)
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(16)
                    .padding(.horizontal, 4)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }

    var subBannerSection: some View {
        Group {
            if let banner = store.state.mainBanners.first {
                KFImage(URL(string: AppConfig.baseURL + banner.imageUrl))
                    .withHeaders()
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        store.action(.didTapBanner(banner))
                    }
            }
        }
    }

    var categorySection: some View {
        HStack(spacing: 0) {
            ForEach(EstateCategory.allCases, id: \.self) { category in
                categoryItem(category)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    func categoryItem(_ category: EstateCategory) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
                    .frame(width: 56, height: 56)

                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.primary)
            }

            Text(category.title)
                .font(.system(size: 12))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
    }

    var recentEstateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "최근검색 매물", action: {})
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(store.state.homeTabTopItems) { item in
                        recentEstateCard(item)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    func recentEstateCard(_ item: HomeTabTopViewDataItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage(item.thumbnail)
                .withHeaders()
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(item.introduction)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 140)
    }

    var hotEstateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "HOT 매물", action: {})
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(store.state.hotItems, id: \.estate_id) { item in
                        hotEstateCard(item)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    func hotEstateCard(_ item: EstateSummaryResponseDTO) -> some View {
        ZStack(alignment: .bottomLeading) {
            if let thumbnailURL = item.thumbnails.first {
                KFImage(URL(string: AppConfig.baseURL + thumbnailURL))
                    .withHeaders()
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 140)
                    .clipped()
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(formatPrice(deposit: item.deposit, monthly: item.monthly_rent))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 4) {
                    Text("\(item.like_count)명이 찜해 보는중")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.8))

                    Spacer()

                    Text(String(format: "%.1fm²", item.area))
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(12)
        }
        .frame(width: 200, height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var dailyTopicSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘의 부동산 TOPIC")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 0) {
                ForEach(store.state.dailyTopics, id: \.title) { topic in
                    dailyTopicRow(topic)

                    if topic.title != store.state.dailyTopics.last?.title {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
    }

    func dailyTopicRow(_ topic: DailyRealEstateDTO) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(topic.content)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(formatDate(topic.date))
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(16)
    }

    func sectionHeader(title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.primary)

            Spacer()

            Button(action: action) {
                Text("View All")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func formatPrice(deposit: Int, monthly: Int) -> String {
        let depositText = deposit >= 10000 ? "\(deposit / 10000),\(String(format: "%03d", deposit % 10000))" : "\(deposit)"
        return "월세 \(depositText)/\(monthly)"
    }

    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.M.d"
        return outputFormatter.string(from: date)
    }
}

// MARK: - Estate Category
private enum EstateCategory: CaseIterable {
    case oneRoom
    case officetel
    case apartment
    case villa
    case commercial

    var title: String {
        switch self {
        case .oneRoom: return "원룸"
        case .officetel: return "오피스텔"
        case .apartment: return "아파트"
        case .villa: return "빌라"
        case .commercial: return "상가"
        }
    }

    var icon: String {
        switch self {
        case .oneRoom: return "bed.double"
        case .officetel: return "building"
        case .apartment: return "building.2"
        case .villa: return "house"
        case .commercial: return "storefront"
        }
    }
}

#Preview {
    PreviewWrapper { preview in
        HomeTabView(store: preview.makeHomeTabStore())
    }
}

