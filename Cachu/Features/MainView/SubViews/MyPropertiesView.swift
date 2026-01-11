import SwiftUI

struct MyPropertiesView: View {
    var body: some View {
        List {
            ForEach(0..<3, id: \.self) { index in
                MyPropertyRow(index: index)
            }
        }
        .listStyle(.plain)
        .navigationTitle("내 매물 관리")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    // 매물 등록
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// MARK: - My Property Row
private struct MyPropertyRow: View {
    let index: Int

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("내 매물 \(index + 1)")
                        .font(.headline)
                    Spacer()
                    Text("공개중")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundStyle(.green)
                        .cornerRadius(4)
                }

                Text("서울시 강남구")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("월세 50/100")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}
