//
//  MerchantDetail.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct MerchantDetail: Codable {
    let id: String
    let name: String
    let category: String
    let logoURL: String
    let latitude: Double
    let longitude: Double
    let address: String
    let phoneNumber: String?
    let email: String?
    let website: String?
    let facebookURL: String?
    let instagramURL: String?
    let whatsappNumber: String?
    let images: [String]
    let openingHours: [OpeningHours]
    let promotions: [MerchantPromotion]
    let description: String
    let categories: [String]
    let mainCategory: String
}
