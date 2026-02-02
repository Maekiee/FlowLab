import SwiftUI
import Combine
import Kingfisher

struct EstateDetailView {
    @Environment(AppRouter.self) private var appRouter

    @State var store: EstateDetailStore

    init(store: EstateDetailStore) {
        self._store = State(initialValue: store)
    }
}

extension EstateDetailView: View {

    var body: some View {
        Group {
            if store.state.isLoading {
                ProgressView()
            } else if let estate = store.state.estate {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // MARK: - Thumbnail
                        TabView {
                            ForEach(estate.thumbnails, id: \.self) { path in
                                KFImage(URL(string: AppConfig.baseURL + path))
                                    .withHeaders()
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 280)
                                    .clipped()
                            }
                        }
                        .frame(height: 280)
                        .tabViewStyle(.page(indexDisplayMode: .automatic))

                        VStack(alignment: .leading, spacing: 24) {
                            // MARK: - Title & Price
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Text(estate.category)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))

                                    if estate.isSafeEstate {
                                        Text("안심매물")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green)
                                            .clipShape(RoundedRectangle(cornerRadius: 4))
                                    }
                                }

                                Text(estate.title)
                                    .font(.system(size: 22, weight: .bold))

                                Text({
                                    let d = Int(estate.deposit)
                                    let m = Int(estate.monthlyRent)
                                    if d >= 10000 {
                                        return "월세 \(d / 10000),\(String(format: "%03d", d % 10000))/\(m)"
                                    }
                                    return "월세 \(d)/\(m)"
                                }())
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.blue)

                                Text(estate.introduction)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                            }

                            Divider()

                            // MARK: - Info
                            VStack(alignment: .leading, spacing: 16) {
                                Text("매물 정보")
                                    .font(.system(size: 18, weight: .bold))

                                VStack(spacing: 12) {
                                    HStack {
                                        Text("면적")
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                            .frame(width: 80, alignment: .leading)
                                        Text(String(format: "%.1fm²", estate.area))
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                    HStack {
                                        Text("층수")
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                            .frame(width: 80, alignment: .leading)
                                        Text(String(format: "%.0f층", estate.floors))
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                    HStack {
                                        Text("주차")
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                            .frame(width: 80, alignment: .leading)
                                        Text(String(format: "%.0f대", estate.parkingCount))
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                    HStack {
                                        Text("관리비")
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                            .frame(width: 80, alignment: .leading)
                                        Text(String(format: "%.0f원", estate.maintenanceFee))
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                    HStack {
                                        Text("준공년도")
                                            .font(.system(size: 15))
                                            .foregroundStyle(.secondary)
                                            .frame(width: 80, alignment: .leading)
                                        Text(estate.builtYear)
                                            .font(.system(size: 15, weight: .medium))
                                    }
                                }
                            }

                            Divider()

                            // MARK: - Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("상세 설명")
                                    .font(.system(size: 18, weight: .bold))

                                Text(estate.description)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                                    .lineSpacing(4)
                            }

                            Divider()

                            // MARK: - Options
                            VStack(alignment: .leading, spacing: 12) {
                                Text("옵션")
                                    .font(.system(size: 18, weight: .bold))

                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                    ForEach(estate.options, id: \.self) { option in
                                        Text(option)
                                            .font(.system(size: 14))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(Color(.systemGray6))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }

                            Divider()

                            // MARK: - Creator
                            VStack(alignment: .leading, spacing: 12) {
                                Text("중개사 정보")
                                    .font(.system(size: 18, weight: .bold))

                                HStack(spacing: 14) {
                                    KFImage(URL(string: AppConfig.baseURL + estate.creator.profileImage))
                                        .withHeaders()
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 56, height: 56)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(estate.creator.nick)
                                            .font(.system(size: 16, weight: .semibold))

                                        Text(estate.creator.introduction)
                                            .font(.system(size: 14))
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Button {
                                        // 채팅 액션
                                    } label: {
                                        Image(systemName: "ellipsis.message")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }

                // MARK: - Bottom Bar
                HStack(spacing: 16) {
                    Button {
                        // 찜 액션
                    } label: {
                        Image(systemName: estate.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundStyle(estate.isLiked ? .red : .secondary)
                    }

                    Button {
                        store.action(.booking)
                    } label: {
                        Text(store.state.isReserved ? "예약완료" : "예약하기")
                            .dsFont(.title1)
                            .foregroundStyle(.gray0)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(store.state.isReserved ? .gray45 : .deepCream)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(store.state.isReserved)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .overlay(alignment: .top) {
                    Divider()
                }

            } else {
                Text("매물 정보를 불러올 수 없습니다.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            store.action(.onAppear)
        }
        .onReceive(store.effect) { effect in
            switch effect {
            case .showPayment:
                if let reservation = store.state.reservationInfo {
                    appRouter.presentFullScreen(
                        .payment(
                            totalPrice: reservation.totalPrice,
                            orderCode: reservation.orderCode
                        )
                    )
                }
            case .showErrorAlert:
                break
            case .showPaymentSuccess:
                break
            case .showPaymentFailure(_):
                break
            }
        }
        .onChange(of: appRouter.paymentResponse?.impUid) { _, newValue in
            if let impUid = newValue {
                store.action(.verifyPayment(impUid: impUid))
                appRouter.paymentResponse = nil
            }
        }
    }
}
