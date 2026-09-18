import Foundation

struct ChatMessageDTO: Encodable {
    let content: String
    let files: [String]?
}
