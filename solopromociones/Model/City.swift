//
//  City.swift
//  solopromociones
//
//  Created by RAVIT Admin on 22/06/24.
//

import Foundation

struct City: Codable, Identifiable, Hashable {
    let name: String
    var id: String { name }
}
