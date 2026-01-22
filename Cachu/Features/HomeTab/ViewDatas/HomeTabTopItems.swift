import Foundation


struct HomeTabTopItems {
    let data: [HomeTabTopItem]
    
    init(from dto: EstateGeoListResponseDTO) {
        self.data = dto.data.map{ HomeTabTopItem(from: $0) }
    }
}

struct HomeTabTopItem: Hashable, Identifiable {
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
