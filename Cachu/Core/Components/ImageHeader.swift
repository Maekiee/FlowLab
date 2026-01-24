import Foundation
import Kingfisher


struct MyImageDownloadRequestModifier: ImageDownloadRequestModifier {
    let accessToken: String

    func modified(for request: URLRequest) -> URLRequest? {
        var modifiedRequest = request
        modifiedRequest.setValue(accessToken, forHTTPHeaderField: AppConfig.AuthorizationName)
        modifiedRequest.setValue(AppConfig.SeSACKey, forHTTPHeaderField: AppConfig.SeSACKeyName)
        return modifiedRequest
    }
}
