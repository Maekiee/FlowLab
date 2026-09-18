import Foundation
import Combine

protocol StoreProtocol {
    associatedtype State
    associatedtype Intent
    associatedtype SideEffect
    
    var state: State { get }
    
    var effect: AnyPublisher<SideEffect, Never> { get }
    
    func action(_ intent: Intent)
}
