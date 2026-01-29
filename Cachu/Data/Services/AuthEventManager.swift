import Foundation
import Combine

enum AuthEvent: Sendable {
    case sessionExpired
}

actor AuthEventManager {
    static let shared = AuthEventManager()
    
    private var continuations: [UUID: AsyncStream<AuthEvent>.Continuation] = [:]
    
    func send(_ event: AuthEvent) {
        continuations.values.forEach { $0.yield(event) }
    }
    
    var events: AsyncStream<AuthEvent> {
        AsyncStream { continuation in
            let id = UUID()
            
            Task { self.addContinuation(id: id, continuation: continuation) }
            
            continuation.onTermination = { _ in
                Task { await self.removeContinuation(id: id) }
            }
        }
    }
    
    private func addContinuation(id: UUID, continuation: AsyncStream<AuthEvent>.Continuation) {
        continuations[id] = continuation
    }
    
    private func removeContinuation(id: UUID) {
        continuations.removeValue(forKey: id)
    }
}
