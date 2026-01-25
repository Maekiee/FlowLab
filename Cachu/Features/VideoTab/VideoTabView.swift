import SwiftUI
import Kingfisher

struct VideoTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(VideoTabRouter.self) private var tabRouter
    
    @State var store: VideoTabStroe
    
    init(store: VideoTabStroe) {
        self._store = State(initialValue: store)
    }
    
    var body: some View {
        @Bindable var videoTabRouter = tabRouter
        
        NavigationStack(path: $videoTabRouter.path) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.state.videoList, id: \.video_id) { video in
                        VideoCardView(video: video)
                            .padding(.bottom, 24)
                            .onTapGesture {
                                // Navigate to details if needed
                            }
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                store.action(.onAppear)
            }
            .navigationTitle("비디오")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: VideoTabRoute.self) { route in
                tabRouter.buildView(for: route)
            }
            .onAppear {
                store.action(.onAppear)
            }
        }
    }
}

// MARK: - Video Card View
private struct VideoCardView: View {
    let video: VideoDTO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Thumbnail Section
            ZStack(alignment: .bottomTrailing) {
                KFImage(URL(string: AppConfig.baseURL + video.thumbnail_url))
                    .withHeaders()
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                // Duration Badge
                Text(formatDuration(video.duration))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(4)
                    .padding(8)
            }
            
            // Info Section
            HStack(alignment: .top, spacing: 12) {
                // Profile/Channel Icon
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: "building.2.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(.gray)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text("Cachu 부동산")
                        Text("•")
                        Text("조회수 \(formatViewCount(video.view_count))회")
                        Text("•")
                        Text(timeAgo(from: video.createdAt))
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    // More action
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundStyle(.primary)
                        .rotationEffect(.degrees(90))
                }
            }
            .padding(.horizontal, 12)
        }.onTapGesture {
            
        }
    }
    
    // MARK: - Helpers
    
    private func formatDuration(_ duration: Double) -> String {
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    private func formatViewCount(_ count: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
    
    private func timeAgo(from dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: dateString) else {
             // Fallback
             let simpleFormatter = ISO8601DateFormatter()
             if let simpleDate = simpleFormatter.date(from: dateString) {
                 return relativeTime(from: simpleDate)
             }
             return dateString
        }
        return relativeTime(from: date)
    }
    
    private func relativeTime(from date: Date) -> String {
        let now = Date()
        let diff = now.timeIntervalSince(date)
        
        let minute: TimeInterval = 60
        let hour: TimeInterval = 60 * minute
        let day: TimeInterval = 24 * hour
        let month: TimeInterval = 30 * day
        let year: TimeInterval = 12 * month
        
        if diff < minute {
            return "방금 전"
        } else if diff < hour {
            return "\(Int(diff / minute))분 전"
        } else if diff < day {
            return "\(Int(diff / hour))시간 전"
        } else if diff < month {
            return "\(Int(diff / day))일 전"
        } else if diff < year {
            return "\(Int(diff / month))개월 전"
        } else {
            return "\(Int(diff / year))년 전"
        }
    }
}
