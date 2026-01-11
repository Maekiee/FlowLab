import SwiftUI

struct PropertyDetailView: View {
    let propertyId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 이미지 영역
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }

                VStack(alignment: .leading, spacing: 16) {
                    // 가격 정보
                    Text("월세 50/100")
                        .font(.title)
                        .fontWeight(.bold)

                    // 주소
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                        Text("서울시 강남구 역삼동")
                    }
                    .foregroundStyle(.secondary)

                    Divider()

                    // 상세 정보
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(title: "방 구조", value: "원룸")
                        InfoRow(title: "면적", value: "33m²")
                        InfoRow(title: "층수", value: "5층")
                        InfoRow(title: "관리비", value: "10만원")
                    }

                    Divider()

                    // 설명
                    Text("매물 설명")
                        .font(.headline)
                    Text("깔끔하고 채광 좋은 원룸입니다. 역에서 도보 5분 거리에 위치해 있습니다.")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("매물 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 관심 등록
                } label: {
                    Image(systemName: "heart")
                }
            }
        }
    }
}

// MARK: - Info Row
private struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
