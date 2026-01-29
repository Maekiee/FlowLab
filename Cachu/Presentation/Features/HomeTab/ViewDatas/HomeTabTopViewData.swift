import Foundation


struct HomeTabTopViewData {
    let data: [HomeTabTopViewDataItem]
    
    init(from dto: EstateGeoListResponseDTO) {
        self.data = dto.data.map{ HomeTabTopViewDataItem(from: $0) }
    }
}

struct HomeTabTopViewDataItem: Hashable, Identifiable {
    let id: String
    let towon: String
    let title: String
    let introduction: String
    let thumbnail: URL?
    
    init(from dto: EstateSummaryResponseDTO) {
        self.id = dto.estate_id
        self.title = dto.title
        self.introduction = dto.introduction
        self.towon = ""
        let url = dto.thumbnails.first ?? ""
        self.thumbnail = URL(string: AppConfig.baseURL + url)
    }
}
