//
//  LoginViewModel.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation
import Combine

enum LoginIntent {
    case loadProfile
}

enum LoginState {
    case idle
    case error(String)
}

@MainActor
final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginState = .idle
    
    private let repository: LoginRepositoryProtocol
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
}
