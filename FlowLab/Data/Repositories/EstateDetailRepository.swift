import Foundation


final class EstateDetailRepository: EstateDetailRepositoryProtocol {
   
    
    private let apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
}

extension EstateDetailRepository {
    func fetchEstateDetail(estateId: String) async throws -> EstateDetailEntity {
        let endPoint = ApiEndpoint.getEstateDetail(estateId: estateId)
        let data = try await apiClient.request(endPoint, type: EstateDetailResponseDTO.self)
        return data.toEntity()
    }
    
    func postOrderReservation(orderInfo: OrderInfoDTO) async throws -> OrderResponseDTO {
        let endPoint = ApiEndpoint.order(orderInfo: orderInfo)

        print("📤 [Order] 요청 바디:", String(data: endPoint.body ?? Data(), encoding: .utf8) ?? "nil")

        do {
            let data = try await apiClient.request(endPoint, type: OrderResponseDTO.self)
            print("✅ [Order] 성공:", data)
            return data
        } catch let error as NetworkError {
            print("❌ [Order] NetworkError:", error)
            throw error
        } catch let error as DecodingError {
            print("❌ [Order] DecodingError:", error)
            throw error
        } catch {
            print("❌ [Order] Error:", error)
            throw error
        }
    }
    
    
    func postValidationReceipt(impUid: ValidationPayDTO) async throws -> ReceiptOrderDTO {
        let endPoint = ApiEndpoint.receiptValid(uid: impUid)
        do {
            let data = try await apiClient.request(endPoint, type: ReceiptOrderDTO.self)
            return data
        } catch let error as NetworkError {
            debugPrint("❌ [영수증 검증] 네트워크 에러", error)
            throw error
        } catch let decodingError as DecodingError {
            debugPrint("❌ [영수증 검증] 디코딩 에러", decodingError)
            throw decodingError
        } catch {
            debugPrint("❌ [영수증 검증] 알 수 없는 에러", error)
            throw error
        }
    }
}
