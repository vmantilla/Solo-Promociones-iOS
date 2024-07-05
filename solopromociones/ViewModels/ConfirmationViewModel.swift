import SwiftUI
import UIKit

class ConfirmationViewModel: ObservableObject {
    @ObservedObject var addPromotionViewModel: AddPromotionViewModel
    
    init(addPromotionViewModel: AddPromotionViewModel) {
        self.addPromotionViewModel = addPromotionViewModel
    }
    
    var title: String { addPromotionViewModel.title }
    var description: String { addPromotionViewModel.description }
    var validUntil: String { formatDate(date: addPromotionViewModel.endDate) }
    var imageURL: String { addPromotionViewModel.imageURL }
    var conditions: String { addPromotionViewModel.conditions }
    var recurrence: RecurrenceType { addPromotionViewModel.recurrence }
    var selectedImage: UIImage? { addPromotionViewModel.selectedImage }
    var selectedLayout: CellLayoutType = .standard
    var startDate: Date { addPromotionViewModel.startDate }
    var endDate: Date { addPromotionViewModel.endDate }
    
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
    
    func addPromotion() {
        let newPromotion = Promotion(
            id: UUID().uuidString,
            title: title,
            description: description,
            validUntil: validUntil,
            imageURL: selectedImage != nil ? saveImageToDocuments(image: selectedImage!)?.absoluteString ?? imageURL : imageURL,
            conditions: conditions, cellType: .standard
        )
        addPromotionViewModel.profileViewModel.addPromotion(newPromotion)
    }
    
    private func saveImageToDocuments(image: UIImage) -> URL? {
        return addPromotionViewModel.saveImageToDocuments(image: image)
    }
}
