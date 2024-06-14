import Combine
import Foundation

struct DayPromotions: Codable, Identifiable {
    var id: String { day }
    let day: String
    let date: String
    let categories: [PromotionCategory]
}

struct PromotionCategory: Codable, Identifiable {
    let id: String
    let category: String
    let promotions: [Promotion]
}

struct Promotion: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let validUntil: String
}
