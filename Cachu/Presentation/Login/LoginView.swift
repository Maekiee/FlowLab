import SwiftUI

struct LoginView: View {
    @Environment(Coordinator.self) var coordinator
    
    init() {
    }
    
    
    var body: some View {
        VStack {
            
            Button {
                print(#function)
            } label: {
                Text("카카오")
            }

            
            Button("Go to Sign up") {
                coordinator.push(.signup)
            }
        }
    }
}

