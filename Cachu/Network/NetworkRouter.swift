
import Foundation

protocol NetworkRouterProtocol {
    func request<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T
}

final class NetworkRouter: NetworkRouterProtocol {
    private let session: URLSession
    private let interceptor: InterceptorProtocol?
    
    init(session: URLSession = .shared, interceptor: InterceptorProtocol? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func request<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        endpoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        // Interceptor: Adapt
        if let interceptor {
            if endpoint.requiresAuth {
                request = await interceptor.adapt(request)
            }
        }
        
        return try await performRequest(request, responseType: responseType)
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.unknown }
        
        // Interceptor: Retry
        if httpResponse.statusCode == 401, let interceptor {
            if let retryRequest = await interceptor.retry(request, with: httpResponse) {
                return try await performRequest(retryRequest, responseType: responseType)
            } else {
                throw NetworkError.unauthorized
            }
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
