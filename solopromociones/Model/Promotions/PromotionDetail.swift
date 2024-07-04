//
//  PromotionDetail.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct PromotionDetail: Codable {
    let id: String
    let title: String
    let description: String
    let validUntil: String
    let images: [String]
    let conditions: String
    var isFavorite: Bool
    let merchant: MerchantDetail
    let otherPromotions: [PromotionSummary]
}
