//
//  Promotion.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

enum CellType: String, Codable {
    case standard = "Standard"
    case carousel = "Carousel"
    case compactHorizontal = "CompactHorizontal"
    case grid = "Grid"
    case featured = "Featured"
    case collapsible = "Collapsible"
    case timeline = "Timeline"
    case comparative = "Comparative"
    case category = "Category"
    case countdown = "Countdown"
}


struct Promotion: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var validUntil: String
    var imageURL: String
    var conditions: String
    var categories: [Category]?
    var cellType: CellType? = .standard
}

