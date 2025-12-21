//
//  AppEnviroment.swift
//  Cachu
//
//  Created by 박도원 on 12/21/25.
//

import Foundation

final class MockTokenManager: TokenManagerProtocol {
    func getAccessToken() async -> String? { return "access_token" }
    func refreshTokens() async throws -> Bool { return true }
}

@MainActor
final class AppEnvironment {
    let container = DIContainer.shared
    
    func setup() {
        Task {
            // 1. Token Manager 등록
            await container.register(TokenManagerProtocol.self) {
                return MockTokenManager()
            }
            
            // 2. Network Service 등록 (Interceptor 포함)
            await container.register(NetworkServiceProtocol.self) {
                // 주의: 실제 코드에서는 resolve가 async이므로
                // 이곳에서 await를 쓰거나, TokenManager를 미리 가져오는 구조가 필요할 수 있음.
                // 여기선 간략화를 위해 Mock 바로 사용 예시
                let interceptor = Interceptor(tokenManager: MockTokenManager())
                return ApiClient(interceptor: interceptor)
            }
            
            // 3. Repository 등록
//            await container.register(UserRepositoryProtocol.self) {
//                // Actor 내부에서 다른 의존성을 resolve 하는 로직은 구조적 설계 필요
//                // 여기서는 개념적 흐름만 표시
//                let network = NetworkClient(interceptor: AuthInterceptor(tokenManager: MockTokenManager()))
//                return UserRepository(network: network)
//            }
        }
    }
}
