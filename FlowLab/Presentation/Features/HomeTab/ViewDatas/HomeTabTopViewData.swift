import Foundation


//struct HomeTabTopViewData {
//    let data: [HomeTabTopViewDataItem]
//    
//    init(from dto: EstateGeoListResponseDTO) {
//        self.data = dto.data.map{ HomeTabTopViewDataItem(from: $0) }
//    }
//}

struct HomeTabTopViewDataItem: Hashable, Identifiable {
    let id: String
    let towon: String
    let title: String
    let introduction: String
    let thumbnail: URL?
    
    init(entity: EstateEntity) {
        self.id = entity.id
        self.title = entity.title
        self.introduction = entity.introduction
        self.towon = ""
        let url = entity.thumbnails.first ?? ""
        self.thumbnail = URL(string: AppConfig.baseURL + url)
    }
}
