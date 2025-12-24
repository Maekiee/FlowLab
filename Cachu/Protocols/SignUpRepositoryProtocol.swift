//
//  SignUpRepositoryProtocol.swift
//  Cachu
//
//  Created by 박도원 on 12/24/25.
//

import Foundation


protocol SignUpRepositoryProtocol {
    func signUp(request: JoinRequestDTO) async throws -> JoinResponseDTO
}
