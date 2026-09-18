import Foundation


struct StreamVideoDTO: Decodable {
    let video_id: String
    let stream_url: String
    let qualities: [StreamQualityDTO]
    let subtitles: [SubtitleDTO]
}


