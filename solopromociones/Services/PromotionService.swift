import Foundation
import Combine

protocol PromotionServiceProtocol {
    func fetchPromotions() async throws -> PromotionData
    func fetchPromotionDetail(id: String) async throws -> PromotionDetail
    func updateFavoriteStatus(promotionId: String, isFavorite: Bool) async throws
}

class PromotionService: PromotionServiceProtocol {
    func fetchPromotions() async throws -> PromotionData {
        return try await withCheckedThrowingContinuation { continuation in
            if let url = Bundle.main.url(forResource: "home", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let promotionData = try decoder.decode(PromotionData.self, from: data)
                    continuation.resume(returning: promotionData)
                } catch {
                    continuation.resume(throwing: error)
                }
            } else {
                continuation.resume(throwing: NSError(domain: "PromotionService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Promotions not found"]))
            }
        }
    }
    
    func fetchPromotionDetail(id: String) async throws -> PromotionDetail {
        return try await withCheckedThrowingContinuation { continuation in
            if let url = Bundle.main.url(forResource: "promotion_detail", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let promotionDetail = try decoder.decode(PromotionDetail.self, from: data)
                    continuation.resume(returning: promotionDetail)
                } catch {
                    continuation.resume(throwing: error)
                }
            } else {
                continuation.resume(throwing: NSError(domain: "PromotionService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Promotion detail not found"]))
            }
        }
    }
    
    func updateFavoriteStatus(promotionId: String, isFavorite: Bool) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
