//
//  Category.swift
//  solopromociones
//
//  Created by Ravit dev on 5/07/24.
//

import Foundation
import SwiftUI

struct Category: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let iconName: String
    let colorString: String
    let promotions: [Promotion]?
    
    var color: Color {
        if colorString.starts(with: "#") {
            return Color(hex: colorString) ?? .gray
        } else {
            return Color(colorString: colorString) ?? .gray
        }
    }
    
    init(id: Int, name: String, iconName: String, color: String, promotions: [Promotion] = []) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorString = color
        self.promotions = promotions
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
