import Combine
import Foundation

class PromotionsViewModel: ObservableObject {
    @Published var days: [DayPromotion] = []
    @Published var selectedDayIndex = 0
    @Published var selectedDate = Date()

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    init() {
        loadPromotions()
    }

    func loadPromotions() {
        guard let url = Bundle.main.url(forResource: "promotions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load promotions data.")
            return
        }

        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode([DayPromotion].self, from: data) {
            self.days = jsonData.sorted {
                dateFormatter.date(from: $0.date)! < dateFormatter.date(from: $1.date)!
            }
            if let today = days.firstIndex(where: {
                calendar.isDateInToday(dateFormatter.date(from: $0.date)!)
            }) {
                selectedDayIndex = today
            }
        }
    }

    var allCategories: [String] {
        Set(days.flatMap { $0.categories.map { $0.category } }).sorted()
    }

    func hasPromotion(on date: Date, category: String?) -> Bool {
        let dateString = dateFormatter.string(from: date)
        guard let dayPromotion = days.first(where: { $0.date == dateString }) else {
            return false
        }

        if let category = category {
            return dayPromotion.categories.contains { $0.category == category && !$0.promotions.isEmpty }
        } else {
            return dayPromotion.categories.contains { !$0.promotions.isEmpty }
        }
    }
    
    func loadPromotionsForDate(_ date: Date) {
        let dateString = dateFormatter.string(from: date)
        if let index = days.firstIndex(where: { $0.date == dateString }) {
            selectedDayIndex = index
            selectedDate = date
        } else {
            // Si no hay promociones para esta fecha, podrías cargar datos adicionales aquí
            // Por ahora, simplemente actualizamos la fecha seleccionada
            selectedDate = date
        }
    }
}

extension PromotionsViewModel {
    func resetToCurrentDay() {
        if let today = days.firstIndex(where: { Calendar.current.isDateInToday(dateFormatter.date(from: $0.date)!) }) {
            selectedDayIndex = today
            selectedDate = Date()
        }
    }
}
