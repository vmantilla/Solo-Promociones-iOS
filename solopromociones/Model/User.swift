//
//  User.swift
//  solopromociones
//
//  Created by RAVIT Admin on 20/06/24.
//

import Foundation


struct UsersContainer: Codable {
    let users: [User]
}

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var isMerchant: Bool
    var promotions: [Promotion]?
}
