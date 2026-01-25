import SwiftUI
import AVKit

struct VideoDetailView: View {
    
    @State var store: VideoDetailStore
    @State private var player: AVPlayer?
    
    init(store: VideoDetailStore) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. 비디오 영역 (16:9 비율)
            videoArea
            
            // 2. 하단 컨텐츠 영역 (스크롤 가능하게 처리)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 여기에 제목, 설명, 댓글 등의 컴포넌트가 들어갑니다.
                    Text("영상 상세 정보가 이곳에 표시됩니다.")
                        .foregroundStyle(.gray)
                        .padding()
                }
            }
            // 남은 공간을 채워서 비디오를 위로 밀어올림 (ScrollView 내용이 적을 경우)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.action(.onAppear)
        }
        // Store의 URL 상태가 변경되면 플레이어를 초기화하고 재생
        .onChange(of: store.state.streamURL) { oldValue, newURL in
            if let url = newURL {
                self.player = AVPlayer(url: url)
                self.player?.play()
            }
        }
        // 뷰가 사라질 때 재생 정지 (선택 사항)
        .onDisappear {
            self.player?.pause()
        }
    }
    
    
    // 비디오 플레이어 뷰 분리
    @ViewBuilder
    private var videoArea: some View {
        ZStack {
            Color.black // 로딩 중이거나 영상 없을 때 검은 배경
            
            if let player = player {
                VideoPlayer(player: player)
            } else {
                if store.state.isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .frame(maxWidth: .infinity) // 가로 꽉 채우기
        .aspectRatio(16/9, contentMode: .fit) // ✅ 핵심: 16:9 비율 고정
    }
}
