//
//  Product.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct Product: Identifiable {
    let id: String
    let title: String
    let description: String
    let expirationDate: Date
    let originalPrice: Double
    let discountedPrice: Double
    let imageURL: String
    let category: String
    let storeName: String
    let storeLogoURL: String
    let distance: Double
}
