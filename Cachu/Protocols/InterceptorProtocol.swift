
import Foundation

protocol InterceptorProtocol {
    func adapt(_ request: URLRequest, for endpoint: Endpoint) async -> URLRequest
    func retry(_ request: URLRequest, dueTo result: Result<HTTPURLResponse, Error>) async -> RetryResult
}


