import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 100
    @State private var selectedRoomType: String = "전체"

    private let roomTypes = ["전체", "원룸", "투룸", "쓰리룸+"]

    var body: some View {
        List {
            // 가격 필터
            Section("가격 범위") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("보증금: \(Int(minPrice))만 ~ \(Int(maxPrice))만")
                        .font(.subheadline)

                    HStack {
                        Text("0")
                        Slider(value: $minPrice, in: 0...500, step: 10)
                        Text("500")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    HStack {
                        Text("0")
                        Slider(value: $maxPrice, in: 0...500, step: 10)
                        Text("500")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            // 방 구조 필터
            Section("방 구조") {
                ForEach(roomTypes, id: \.self) { type in
                    HStack {
                        Text(type)
                        Spacer()
                        if selectedRoomType == type {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedRoomType = type
                    }
                }
            }
        }
        .navigationTitle("필터")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("적용") {
                    dismiss()
                }
            }
        }
    }
}
