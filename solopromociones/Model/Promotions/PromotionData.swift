//
//  PromotionData.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct PromotionData: Codable {
    let promotions: [Promotion]
    let categories: [String]
}
