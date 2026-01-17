import Foundation
import Combine

@MainActor
@Observable
final class HomeTabStore: StoreProtocol {
    struct State {
        
    }
    
    enum Intent {
        case onApper
    }
    
    enum SideEffect {
        
    }
    
    private(set) var state = State()
    private let repository: HomeTabRepositoryProtocol
    private let tokenManager: TokenManagerProtocol
    
    private let effectSubject = PassthroughSubject<SideEffect, Never>()
    var effect: AnyPublisher<SideEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    init(
        repository: HomeTabRepositoryProtocol,
        tokenManager: TokenManagerProtocol
    ) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func action(_ intent: Intent) {
        switch intent {
        case .onApper:
            fetchBanner()
            fetchHotProperties()
            fetchDailyRealEstateTopics()
        }
    }
}

extension HomeTabStore {
    private func fetchBanner() {
        Task {
            do {
                let res = try await repository.getBanner()
            } catch {
                print("❌ 통신 에러: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("🔑 키를 찾을 수 없음: '\(key.stringValue)'")
                        print("경로: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                    case .typeMismatch(let type, let context):
                        print("🔀 타입 불일치: \(type)")
                        print("   경로: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                    case .valueNotFound(let type, let context):
                        print("📭 값이 없음: \(type)")
                        print("   경로: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))")
                    case .dataCorrupted(let context):
                        print("💥 데이터 손상: \(context.debugDescription)")
                    @unknown default:
                        print("🤷 알 수 없는 디코딩 에러")
                    }
                }
            }
        }
    }
    
    private func fetchHotProperties() {
        Task {
            do {
                let res = try await repository.getHotProperties()
            } catch {
                // 네트웤 에러 추가
                print("‼️‼️핫 매물 네트워크 호출 실패")
            }
        }
    }
    
    private func fetchDailyRealEstateTopics() {
        Task {
            do {
                let res = try await repository.getDailyRealEstateTopics()
            } catch {
                // 네트워크 에러 추가
                print("‼️‼️오늘의 부동산 토픽 네트워크 호출 실패")
            }
        }
    }
}
