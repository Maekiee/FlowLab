import Foundation

protocol KeychainManagerProtocol: Sendable {
    func save(data: Data, service: String, account: String) throws
    func read(service: String, account: String) -> Data?
    func delete(service: String, account: String) throws
}
