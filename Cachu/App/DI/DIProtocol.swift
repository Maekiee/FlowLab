import Foundation

protocol DIContainerProtocol: Sendable {
    func register<T>(_ type: T.Type, factory: @escaping @Sendable () -> T) async
    func resolve<T>(_ type: T.Type) async -> T
}
