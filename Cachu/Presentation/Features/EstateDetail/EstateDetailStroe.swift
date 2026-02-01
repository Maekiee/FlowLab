import Foundation
import Combine



@MainActor @Observable
final class EstateDetailStore: StoreProtocol {
    private(set) var state = State()
    private let repository: EstateDetailRepositoryProtocol
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: EstateDetailRepositoryProtocol,
        estateId: String
    ) {
        self.repository = repository
        self.state.estateId = estateId
    }
    
    struct State {
        var isLoading = false
        var estateId = ""
        var estate: EstateDetailEntity?
        var isReserved = false
        var errorMessage: String?
        var orderInfo: OrderInfoDTO?
        var reservationInfo: ReservationInfoEntity?
    }

    enum Intent {
        case onAppear
        case booking
        case dismissPayment
    }

    enum SideEffect {
        case showErrorAlert(String)
        case showPayment
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onAppear:
            getEstateDetail()
        case .booking:
            booking()
        case .dismissPayment:
            state.reservationInfo = nil
        }
    }
}


extension EstateDetailStore {
    private func getEstateDetail() {
        Task {
            state.isLoading = true
            
            defer { state.isLoading = false }
            
            do {
                let estateDetail = try await repository.fetchEstateDetail(estateId: state.estateId)
                state.estate = estateDetail
                state.isReserved = estateDetail.isReserved
                state.orderInfo = OrderInfoDTO(estate_id: estateDetail.id, total_price: estateDetail.reservationPrice)
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
    
    private func booking() {
        Task {
            
            guard let orderInfo = state.orderInfo else { return }
            
            do {
                let response = try await repository.postOrderReservation(orderInfo: orderInfo)
                state.reservationInfo = response.toEntity()
                effectSubject.send(.showPayment)
            } catch let error as NetworkError {
                effectSubject.send(.showErrorAlert(error.errorDescription))
            } catch {
                effectSubject.send(.showErrorAlert(error.localizedDescription))
            }
        }
    }
    
    private func payment() {
        
    }
}
