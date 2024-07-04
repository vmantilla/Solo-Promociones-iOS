//
//  User.swift
//  solopromociones
//
//  Created by RAVIT Admin on 20/06/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: Int
    var name: String?
    var email: String
    var isMerchant: Bool = false
    var anonymous: Bool
    var promotions: [Promotion]?
}
