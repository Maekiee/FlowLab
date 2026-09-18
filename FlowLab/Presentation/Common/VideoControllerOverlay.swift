import SwiftUI
import AVFoundation

enum OrientationLock {
    @MainActor static var allowLandscape: Bool = false
}

@Observable
final class VideoPlayerState {

    var isPlaying: Bool = false
    var currentTime: Double = 0
    var duration: Double = 0
    var showControls: Bool = true
    var isSeeking: Bool = false
    var isFullscreen: Bool = false

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var hideTask: Task<Void, Never>?

    var currentTimeText: String {
        formatTime(currentTime)
    }

    var durationText: String {
        formatTime(duration)
    }

    func bind(player: AVPlayer) {
        guard self.player !== player else { return }
        unbind()
        self.player = player

        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self, !self.isSeeking else { return }
            self.currentTime = time.seconds
            if let item = player.currentItem {
                let dur = item.duration.seconds
                if dur.isFinite { self.duration = dur }
            }
        }

        isPlaying = player.rate != 0
        scheduleHide()
    }

    func unbind() {
        if let observer = timeObserver, let player {
            player.removeTimeObserver(observer)
        }
        timeObserver = nil
        hideTask?.cancel()
        player = nil
    }

    func togglePlayPause() {
        guard let player else { return }
        if player.rate == 0 {
            player.play()
            isPlaying = true
        } else {
            player.pause()
            isPlaying = false
        }
        scheduleHide()
    }

    func seek(to time: Double) {
        guard let player else { return }
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        currentTime = time
    }

    func skipForward() {
        let target = min(currentTime + 10, duration)
        seek(to: target)
        scheduleHide()
    }

    func skipBackward() {
        let target = max(currentTime - 10, 0)
        seek(to: target)
        scheduleHide()
    }

    func toggleControls() {
        showControls.toggle()
        if showControls {
            scheduleHide()
        }
    }

    func scheduleHide() {
        hideTask?.cancel()
        guard showControls else { return }
        hideTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            self?.showControls = false
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let total = Int(seconds)
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }
}

struct VideoControllerOverlay: View {

    let playerState: VideoPlayerState
    var qualities: [StreamQualityDTO] = []
    var currentQualityName: String = "Auto"
    var onChangeQuality: ((StreamQualityDTO?) -> Void)?

    var body: some View {
        ZStack {
            // 탭 영역
            tapLayer

            if playerState.showControls {
                controlsOverlay
            }
        }
        .animation(.easeInOut(duration: 0.2), value: playerState.showControls)
    }

    // MARK: - Tap Layer (더블탭 + 싱글탭)

    private var tapLayer: some View {
        HStack(spacing: 0) {
            // 좌측 더블탭 → 10초 뒤로
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    playerState.skipBackward()
                }
                .onTapGesture(count: 1) {
                    playerState.toggleControls()
                }

            // 우측 더블탭 → 10초 앞으로
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    playerState.skipForward()
                }
                .onTapGesture(count: 1) {
                    playerState.toggleControls()
                }
        }
    }

    // MARK: - Controls Overlay

    private var controlsOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .allowsHitTesting(false)

            // 중앙 컨트롤
            centerControls

            // 하단 바
            VStack {
                Spacer()
                bottomBar
            }
        }
    }

    private var centerControls: some View {
        HStack(spacing: 40) {
            Button {
                playerState.skipBackward()
            } label: {
                Image(systemName: "gobackward.10")
                    .font(.title)
                    .foregroundStyle(.white)
            }

            Button {
                playerState.togglePlayPause()
            } label: {
                Image(systemName: playerState.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
            }

            Button {
                playerState.skipForward()
            } label: {
                Image(systemName: "goforward.10")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 8) {
            Text(playerState.currentTimeText)
                .font(.caption)
                .foregroundStyle(.white)
                .monospacedDigit()

            Slider(
                value: Binding(
                    get: { playerState.currentTime },
                    set: { newValue in
                        playerState.isSeeking = true
                        playerState.currentTime = newValue
                    }
                ),
                in: 0...(max(playerState.duration, 1))
            ) { editing in
                if !editing {
                    playerState.seek(to: playerState.currentTime)
                    playerState.isSeeking = false
                    playerState.scheduleHide()
                }
            }
            .tint(.white)

            Text(playerState.durationText)
                .font(.caption)
                .foregroundStyle(.white)
                .monospacedDigit()

            qualityMenu

            Button {
                playerState.isFullscreen.toggle()
            } label: {
                Image(systemName: playerState.isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                    .font(.callout)
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }

    private var qualityMenu: some View {
        Menu {
            Button {
                onChangeQuality?(nil)
            } label: {
                HStack {
                    Text("Auto")
                    if currentQualityName == "Auto" {
                        Image(systemName: "checkmark")
                    }
                }
            }

            ForEach(qualities, id: \.self) { quality in
                Button {
                    onChangeQuality?(quality)
                } label: {
                    HStack {
                        Text(quality.quality)
                        if currentQualityName == quality.quality {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.callout)
                .foregroundStyle(.white)
        }
    }
}
