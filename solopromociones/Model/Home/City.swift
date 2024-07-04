//
//  City.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct City: Identifiable, Codable {
    var id: Int
    var name: String
    var code: String
    var country: String

    enum CodingKeys: String, CodingKey {
        case id, name, code, country
    }
}
