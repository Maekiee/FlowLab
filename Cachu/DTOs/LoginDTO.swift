//
//  LoginDTO.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation


struct LoginDTO: Decodable, Sendable {
    let user_id: String
    let email: String
    let profileImage: String
    let accessToken: String
    let refreshToken: String
}
