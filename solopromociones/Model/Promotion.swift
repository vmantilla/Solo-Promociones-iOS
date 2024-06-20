import Foundation

struct DayPromotion: Identifiable, Codable {
    var id: String { day }
    var day: String
    var date: String
    var categories: [DayCategory]
    
    var formattedDay: String {
        // Asume que 'day' ya es el nombre del día
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
}
