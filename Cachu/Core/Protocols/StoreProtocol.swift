import Foundation


protocol StoreProtocol {
    associatedtype State
    associatedtype Intent
    associatedtype SideEffect
    
    var state: State { get }
    
    func action(_ intent: Intent)
}
