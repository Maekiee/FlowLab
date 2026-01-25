import Foundation

struct VideoStreamDTO: Decodable {
    let video_id: String
    let stream_url: String
    let qualities: [StreamQualityDTO]
    let subtitles: [SubtitleDTO]
}


struct StreamQualityDTO: Decodable {
    let quality: String
    let url: String
}

struct SubtitleDTO: Decodable {
    let language: String
    let name: String
    let is_default: Bool
    let url: String
}
