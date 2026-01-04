import Foundation

enum RetryResult: Sendable {
    case retry
    case doNotRetry
    case doNotRetryWithError(Error)
}
