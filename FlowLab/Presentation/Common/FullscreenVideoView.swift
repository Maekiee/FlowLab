import SwiftUI
import AVFoundation

struct FullscreenVideoView: View {

    let player: AVPlayer?
    let playerState: VideoPlayerState
    var qualities: [StreamQualityDTO] = []
    var currentQualityName: String = "Auto"
    var onChangeQuality: ((StreamQualityDTO?) -> Void)?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let player {
                VideoPlayerView(player: player)
                    .ignoresSafeArea()

                VideoControllerOverlay(
                    playerState: playerState,
                    qualities: qualities,
                    currentQualityName: currentQualityName,
                    onChangeQuality: onChangeQuality
                )
                .ignoresSafeArea()
            }
        }
        .persistentSystemOverlays(.hidden)
        .statusBarHidden(true)
        .onAppear {
            OrientationLock.allowLandscape = true
            setLandscape(true)
        }
        .onDisappear {
            setLandscape(false)
            OrientationLock.allowLandscape = false
        }
    }

    private func setLandscape(_ landscape: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }

        if landscape {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        } else {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }

        // supportedInterfaceOrientations 업데이트를 위해 setNeedsUpdateOfSupportedInterfaceOrientations 호출
        if let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
