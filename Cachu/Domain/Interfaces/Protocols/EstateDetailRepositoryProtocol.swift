import Foundation

protocol EstateDetailRepositoryProtocol {
    func fetchEstateDetail(estateId: String) async throws -> EstateDetailEntity
}
