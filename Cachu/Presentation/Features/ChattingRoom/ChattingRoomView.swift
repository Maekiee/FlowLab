import SwiftUI

struct ChattingRoomView: View {
    let roomId: String

    var body: some View {
        Text("채팅방 ID: \(roomId)")
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    ChattingRoomView(roomId: "preview-room-id")
}
