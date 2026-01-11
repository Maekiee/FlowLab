import SwiftUI

struct FavoriteTabView: View {
    let coordinator: FavoriteCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if true { // TODO: 실제 데이터로 교체
                    // 관심 매물 목록 예시
                    ForEach(0..<5, id: \.self) { index in
                        FavoritePropertyRow(
                            propertyId: "property-\(index)",
                            onTap: {
                                coordinator.push(.propertyDetail(id: "property-\(index)"))
                            }
                        )
                    }
                } else {
                    // 빈 상태
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("관심 매물이 없습니다")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                }
            }
            .padding()
        }
        .navigationTitle("관심 목록")
    }
}

// MARK: - Favorite Property Row
struct FavoritePropertyRow: View {
    let propertyId: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("매물 \(propertyId)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("서울시 강남구")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("월세 50/100")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }

                Spacer()

                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
    }
}
