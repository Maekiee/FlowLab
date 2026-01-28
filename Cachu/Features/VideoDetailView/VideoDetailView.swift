import SwiftUI
import AVKit

struct VideoDetailView: View {

    @State var store: VideoDetailStore
    @State private var player: AVPlayer?
    @State private var playerState = VideoPlayerState()

    init(store: VideoDetailStore) {
        self._store = State(initialValue: store)
    }

    var body: some View {
        VStack(spacing: 0) {

            ZStack {
                Color.black

                if let player = player {
                    VideoPlayerView(player: player)

                    VideoControllerOverlay(
                        playerState: playerState,
                        qualities: store.state.qualities,
                        currentQualityName: store.state.currentQualityName,
                        onChangeQuality: { quality in
                            store.action(.changeQuality(quality))
                        }
                    )
                } else if store.state.isLoading {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("영상 상세 정보가 이곳에 표시됩니다.")
                        .foregroundStyle(.gray)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.action(.onAppear)
        }
        .onChange(of: store.state.streamURL) { oldValue, newURL in
            updatePlayerURL(newURL)
        }
        .onDisappear {
            player?.pause()
            playerState.unbind()
        }
        .fullScreenCover(isPresented: Binding(
            get: { playerState.isFullscreen },
            set: { playerState.isFullscreen = $0 }
        )) {
            FullscreenVideoView(
                player: player,
                playerState: playerState,
                qualities: store.state.qualities,
                currentQualityName: store.state.currentQualityName,
                onChangeQuality: { quality in
                    store.action(.changeQuality(quality))
                }
            )
        }
    }

    private func updatePlayerURL(_ url: URL?) {
        guard let url = url else { return }

        let currentTime: CMTime = player?.currentTime() ?? .zero
        let isPlaying = player?.rate != 0

        let newItem = AVPlayerItem(url: url)

        if player == nil {
            let newPlayer = AVPlayer(playerItem: newItem)
            player = newPlayer
            playerState.bind(player: newPlayer)
            newPlayer.play()
            playerState.isPlaying = true
        } else {
            player?.replaceCurrentItem(with: newItem)

            player?.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                if isPlaying {
                    player?.play()
                }
            }
        }
    }
}
