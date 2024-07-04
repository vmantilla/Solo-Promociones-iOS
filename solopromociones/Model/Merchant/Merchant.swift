//
//  Merchant.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct Merchant: Identifiable, Codable {
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
}
