//
//  DayCategory.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct DayCategory: Identifiable, Codable {
    var id: String
    var category: String
    var promotions: [Promotion]
}
