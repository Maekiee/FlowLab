//
//  LoginRepository.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//
//
//import Foundation
//
//final class LoginRepository: LoginRepositoryProtocol {
//    private let router: NetworkRouterProtocol
//    
//    init(router: NetworkRouterProtocol) {
//        self.router = router
//    }
//    
//    func login() async throws -> LoginDTO {
//        return try await router.request(APIEndpoint.userProfile, responseType: LoginDTO.self)
//    }
//    
//    
//}
