import SwiftUI

struct HomeTabView: View {
    let coordinator: HomeCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("홈 화면")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // 예시 버튼들
                Button {
                    coordinator.push(.propertyList)
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

                Button {
                    coordinator.push(.propertyDetail(id: "sample-123"))
                } label: {
                    HStack {
                        Image(systemName: "house")
                        Text("매물 상세 보기")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }

                Button {
                    coordinator.push(.notification)
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
            }
            .padding()
        }
        .navigationTitle("홈")
    }
}
