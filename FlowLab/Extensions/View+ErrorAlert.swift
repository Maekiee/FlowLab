import SwiftUI

struct NetworkErrorAlertModify: ViewModifier {
    @Binding var errorMessage: String?
    
    var isPresented: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .alert("알림", isPresented: isPresented) {
                Button("확인", role: .cancel) { }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
    }
}

extension View {
    func errorAlert(message: Binding<String?>) -> some View {
        modifier(NetworkErrorAlertModify(errorMessage: message))
    }
}
