//
//  PromotionSummary.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct PromotionSummary: Codable, Identifiable {
    let id: String
    let title: String
    let imageURL: String
}
