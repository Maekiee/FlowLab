import SwiftUI

struct NotificationView: View {
    var body: some View {
        List {
            ForEach(0..<5, id: \.self) { index in
                NotificationRow(index: index)
            }
        }
        .listStyle(.plain)
        .navigationTitle("알림")
    }
}

// MARK: - Notification Row
private struct NotificationRow: View {
    let index: Int

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("새로운 매물이 등록되었습니다")
                    .font(.subheadline)
                Text("\(index + 1)시간 전")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
