import Foundation

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
}

struct DayPromotion: Identifiable, Codable {
    var id: String { day }
    var day: String
    var date: String
    var categories: [DayCategory]
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "EEEE d"
            return dateFormatter.string(from: date)
        }
        return date
    }
}
