import Foundation

protocol EntityConvertible {
    associatedtype DomainEntity
    func toEntity() -> DomainEntity
}
