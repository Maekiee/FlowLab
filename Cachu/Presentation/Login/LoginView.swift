//
//  LoginView.swift
//  Cachu
//
//  Created by 박도원 on 12/20/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            
            Button("회원가입 요청") {
                viewModel.requestSignUp()
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
