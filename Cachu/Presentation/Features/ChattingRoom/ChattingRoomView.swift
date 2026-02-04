import SwiftUI

struct ChattingRoomView: View {
    var body: some View {
        Text("hello Chatting")
            .toolbar(.hidden, for:.tabBar)
    }
}

#Preview {
    ChattingRoomView()
}
