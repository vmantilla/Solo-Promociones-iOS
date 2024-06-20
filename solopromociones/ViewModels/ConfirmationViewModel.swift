import Foundation
import UIKit

class ConfirmationViewModel: ObservableObject {
    let title: String
    let description: String
    let validUntil: String
    let imageURL: String
    let conditions: String
    let recurrence: RecurrenceType
    let selectedImage: UIImage?
    let selectedLayout: CellLayoutType
    let startDate: Date
    let endDate: Date
    
    init(title: String, description: String, validUntil: String, imageURL: String, conditions: String, recurrence: RecurrenceType, selectedImage: UIImage?, selectedLayout: CellLayoutType, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.validUntil = validUntil
        self.imageURL = imageURL
        self.conditions = conditions
        self.recurrence = recurrence
        self.selectedImage = selectedImage
        self.selectedLayout = selectedLayout
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func generatePromotionDates() -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            switch recurrence {
            case .none, .daily:
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            case .weekly:
                currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
            case .monthly:
                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
            case .yearly:
                currentDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) ?? currentDate
            }
        }
        
        return dates
    }
    
    func calculateTotalCost() -> String {
        let dates = generatePromotionDates()
        let costPerDay = 10 // Suponiendo un costo fijo por día
        let totalCost = dates.count * costPerDay
        
        return "$\(totalCost)"
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
