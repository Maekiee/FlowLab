import Foundation


struct Banners {
    let data: [Banner]
    
    init(from dto: EstateGeoListResponseDTO) {
        self.data = dto.data.map{ Banner(from: $0) }
    }
}

struct Banner: Hashable, Identifiable {
    let id: String
    let title: String
    let introduction: String
    let thumbnail: URL?
    
    init(from dto: EstateSummaryResponseDTO) {
        self.id = dto.estate_id
        self.title = dto.title
        self.introduction = dto.introduction
        
        let url = dto.thumbnails.first ?? ""
        self.thumbnail = URL(string: AppConfig.baseURL + url)
    }
}
