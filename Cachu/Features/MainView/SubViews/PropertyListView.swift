import SwiftUI

struct PropertyListView: View {
    var body: some View {
        List {
            ForEach(0..<10, id: \.self) { index in
                PropertyListRow(index: index)
            }
        }
        .listStyle(.plain)
        .navigationTitle("매물 목록")
    }
}

// MARK: - Property List Row
private struct PropertyListRow: View {
    let index: Int

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 80)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("매물 \(index + 1)")
                    .font(.headline)
                Text("서울시 강남구")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("월세 \(50 + index * 5)/\(80 + index * 10)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
