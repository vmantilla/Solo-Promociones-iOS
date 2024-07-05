import Foundation
import Combine

protocol PromotionServiceProtocol {
    func fetchPromotions() async throws -> PromotionData
    func fetchPromotionDetail(id: String) async throws -> PromotionDetail
    func updateFavoriteStatus(promotionId: String, isFavorite: Bool) async throws
    func fetchDailyPromotions() async throws -> [DayPromotion]
}

class PromotionService: PromotionServiceProtocol {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
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
    
    func fetchDailyPromotions() async throws -> [DayPromotion] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let url = Bundle.main.url(forResource: "daily_promotions", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                continuation.resume(throwing: NSError(domain: "PromotionService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to load promotions data"]))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode([DayPromotion].self, from: data)
                let sortedData = jsonData.sorted {
                    dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)!
                }
                continuation.resume(returning: sortedData)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
