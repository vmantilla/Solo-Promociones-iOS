import Foundation
import SwiftUI

struct DayPromotion: Identifiable, Codable {
    var id: String { day }
    var day: String
    var date: String
    var categories: [DayCategory]
    
    var formattedDay: String {
        return day
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: self.date) {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        return date
    }
}

struct DayCategory: Identifiable, Codable {
    var id: String
    var category: String
    var promotions: [Promotion]
}

struct Promotion: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var validUntil: String
    var imageURL: String
    var conditions: String
    var category: String? = ""
}

struct City: Identifiable, Codable {
    var id: String { name }
    var name: String
}


struct Day: Identifiable {
    let id = UUID()
    let date: Date
    var categories: [DayCategory]
    
    var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}


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

