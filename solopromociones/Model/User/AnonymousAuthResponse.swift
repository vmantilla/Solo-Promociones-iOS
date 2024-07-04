//
//  AnonymousAuthResponse.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct AnonymousAuthResponse: Codable {
    let token: String
    let user: AuthUser
}

struct AuthUser: Codable {
    let id: Int
    let email: String
    let anonymous: Bool
}
