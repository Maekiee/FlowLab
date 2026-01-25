import Foundation
import Security

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}


actor KeychainService: KeychainServiceProtocol {
    
    init() {}
    
    func save(data: Data, service: String, account: String) throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]
            
            // 동기 API인 SecItem 함수들을 그대로 사용하되, actor 내부에서 실행되므로
            // 호출하는 쪽(MainActor)에서는 await로 기다리게 되어 UI 블로킹이 발생하지 않음 (컨텍스트 스위칭).
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status == errSecSuccess else {
                throw KeychainError.unexpectedStatus(status)
            }
        }
        
        nonisolated func read(service: String, account: String) -> Data? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess {
                return item as? Data
            }
            return nil
        }
        
        func delete(service: String, account: String) throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            
            // 삭제하려는 아이템이 없어도 에러가 아님
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw KeychainError.unexpectedStatus(status)
            }
        }
    
    func save(token: String, service: String, account: String) async throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.invalidItemFormat
        }
        try save(data: data, service: service, account: account)
    }
    
    func readToken(service: String, account: String) async -> String? {
        guard let data = read(service: service, account: account) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
