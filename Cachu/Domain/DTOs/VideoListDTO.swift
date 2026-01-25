import Foundation

struct VideoListDTO: Decodable {
    let data: [VideoDTO]
    let next_cursor: String?
}


struct VideoDTO: Decodable {
    let video_id: String
    let file_name: String
    let title: String
    let description: String
    let duration: Double
    let thumbnail_url: String
    let available_qualities: [String]
    let view_count: Int
    let like_count: Int
    let is_liked: Bool
    let createdAt: String
}
