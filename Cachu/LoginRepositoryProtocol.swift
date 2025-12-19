//
//  LoginRepositoryProtocol.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation


protocol LoginRepositoryProtocol {
    func login() async throws -> LoginDTO
}
