import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            // 검색 결과
            if searchText.isEmpty {
                // 최근 검색어
                List {
                    Section("최근 검색") {
                        ForEach(["강남역", "역삼동", "서초동"], id: \.self) { keyword in
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.secondary)
                                Text(keyword)
                                Spacer()
                            }
                        }
                    }

                    Section("인기 검색어") {
                        ForEach(["홍대입구", "신촌", "합정"], id: \.self) { keyword in
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                                Text(keyword)
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                // 검색 결과
                List {
                    ForEach(0..<5, id: \.self) { index in
                        HStack {
                            Image(systemName: "mappin.circle")
                                .foregroundStyle(.red)
                            Text("\(searchText) 검색 결과 \(index + 1)")
                            Spacer()
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "지역, 지하철역 검색")
        .navigationTitle("검색")
    }
}
