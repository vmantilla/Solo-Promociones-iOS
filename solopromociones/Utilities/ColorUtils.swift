//
//  ColorUtils.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation
import SwiftUI

func colorForCategory(_ category: String? = "") -> Color {
    let colors: [String: Color] = [
        "Comida": .red,
        "Bebidas": .blue,
        "Entretenimiento": .green,
        "Compras": .orange,
        "Deportes": .purple,
        "Tecnología": .pink,
        "Viajes": .yellow,
        "Educación": .teal,
        "Salud": .indigo,
        "Hogar": .brown,
        "Música": .cyan,
        "Arte": .mint,
        "Belleza": .gray,
        "Mascotas": .black,
        "Finanzas": .purple,
        "Juegos": .orange,
        "Bebés": .blue,
        "Bailes": .pink
    ]
    
    // Si la categoría tiene un color predefinido, lo usamos
    if let categoryColor = colors[category ?? ""] {
        return categoryColor
    }
    
    // Si la categoría no tiene un color predefinido, seleccionamos un color aleatorio
    let randomColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .teal, .indigo, .brown, .cyan, .mint, .gray, .black]
    return randomColors.randomElement() ?? .gray
}
