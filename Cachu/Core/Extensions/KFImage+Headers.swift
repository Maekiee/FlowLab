import Foundation
import Kingfisher
import SwiftUI

// MARK: - Auth Header Modifier
struct AuthHeaderModifier: ImageDownloadRequestModifier {
    // KeychainService is an actor but 'read' is nonisolated, allowing synchronous access.
    // However, creating a new actor instance is cheap if it holds no state.
    // Alternatively, we could use a static helper if available.
    // Here we create a local instance to access the nonisolated method.
    private let keychain = KeychainService()
    
    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
        
        // Add SeSAC Key (Always required)
        modifiedRequest.setValue(AppConfig.SeSACKey, forHTTPHeaderField: AppConfig.SeSACKeyName)
        
        // Add Access Token if available
        if let data = keychain.read(service: AppConfig.bundleID, account: AppConfig.accessTokenKey),
           let accessToken = String(data: data, encoding: .utf8) {
            modifiedRequest.setValue(accessToken, forHTTPHeaderField: AppConfig.AuthorizationName)
        }
        
        return modifiedRequest
    }
}

// MARK: - KFImage Extension
extension KFImage {
    /// Applies the default authentication headers (AccessToken & SeSACKey) to the image request.
    func withHeaders() -> KFImage {
        return self.requestModifier(AuthHeaderModifier())
    }
}
