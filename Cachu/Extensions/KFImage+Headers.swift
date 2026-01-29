import Kingfisher
import SwiftUI

// MARK: - Auth Header Modifier
struct AuthHeaderModifier: ImageDownloadRequestModifier {
    private let keychain = KeychainService()
    
    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
    
        modifiedRequest.setValue(AppConfig.SeSACKey, forHTTPHeaderField: AppConfig.SeSACKeyName)
        
        if let data = keychain.read(service: AppConfig.bundleID, account: AppConfig.accessTokenKey),
           let accessToken = String(data: data, encoding: .utf8) {
            modifiedRequest.setValue(accessToken, forHTTPHeaderField: AppConfig.AuthorizationName)
        }
        
        return modifiedRequest
    }
}

// MARK: - KFImage Extension
extension KFImage {
    func withHeaders() -> KFImage {
        return self.requestModifier(AuthHeaderModifier())
    }
}
