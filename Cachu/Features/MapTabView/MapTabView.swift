import SwiftUI

struct MapTabView: View {
    let coordinator: MapCoordinator

    var body: some View {
        VStack(spacing: 20) {
            // 지도 영역 (placeholder)
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                Text("지도 영역")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 하단 버튼들
            HStack(spacing: 16) {
                Button {
                    coordinator.push(.search)
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("검색")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }

                Button {
                    coordinator.push(.filter)
                } label: {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("필터")
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("지도")
    }
}
