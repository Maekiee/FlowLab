
import Foundation

protocol InterceptorProtocol {
    func adapt(_ request: URLRequest) async -> URLRequest
    func retry(_ request: URLRequest, with response: HTTPURLResponse) async -> URLRequest?
}
