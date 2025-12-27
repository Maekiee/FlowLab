import SwiftUI

struct LoginView: View {
    @Environment(Coordinator.self) var coordinator
    
    init() {
    }
    
    
    var body: some View {
        VStack {
            Text("Login View")
            
            Button("Go to Sign up") {
                coordinator.push(.signup)
            }
        }
    }
}

