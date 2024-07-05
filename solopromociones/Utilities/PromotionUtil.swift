//
//  PromotionUtil.swift
//  solopromociones
//
//  Created by Ravit dev on 5/07/24.
//

import Foundation

struct PromotionUtil {
    static func filterPromotionsByCellType(promotions: [Promotion], cellType: CellType) -> [Promotion] {
        return promotions.filter { $0.cellType == cellType }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
