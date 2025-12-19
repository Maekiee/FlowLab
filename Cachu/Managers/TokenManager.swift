//
//  TokenManager.swift
//  Cachu
//
//  Created by 박도원 on 12/19/25.
//

import Foundation

actor TokenManager {
    static let shared = TokenManager()
    
    private var accessToken: String?
    private var refreshToken: String?
    
    private init() {}
    
    func saveTokens(access: String, refresh: String) {
        self.accessToken = access
        self.refreshToken = refresh
        // TODO: 실무에서는 Keychain에 저장하는 로직을 추가하세요.
    }
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func getRefreshToken() -> String? {
        return refreshToken
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        // TODO: Keychain 삭제 로직 추가
    }
}
