//
//  Promotion.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct Promotion: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var validUntil: String
    var imageURL: String
    var conditions: String
    var category: String? = ""
    var merchant: Merchant?
}
