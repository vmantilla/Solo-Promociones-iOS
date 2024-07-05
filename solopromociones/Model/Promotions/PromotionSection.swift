//
//  PromotionSection.swift
//  solopromociones
//
//  Created by Ravit dev on 5/07/24.
//

import Foundation

struct PromotionSection: Identifiable, Codable {
    var id: String { title }
    var title: String
    var cellType: CellType
    var promotions: [Promotion]
}
