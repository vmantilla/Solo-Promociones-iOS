import Combine
import Foundation

class PromotionsViewModel: ObservableObject {
    @Published var days: [DayPromotion] = []
    @Published var selectedDayIndex = 0
    @Published var selectedDate = Date()
    @Published var selectedCategory: Category? = nil
    @Published var categories: [Category] = []

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    init() {
        loadPromotions()
        loadCategories()
    }

    func loadPromotions() {
        guard let url = Bundle.main.url(forResource: "daily_promotions", withExtension: "json"),
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
    
    func loadCategories() {
        guard let url = Bundle.main.url(forResource: "categories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load categories data.")
            return
        }
        
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode([Category].self, from: data) {
            self.categories = jsonData
        }
    }

    var allCategories: [Category] {
        return categories
    }

    func hasPromotion(on date: Date, category: Category?) -> Bool {
        let dateString = dateFormatter.string(from: date)
        guard let dayPromotion = days.first(where: { $0.date == dateString }) else {
            return false
        }

        if let category = category {
            return dayPromotion.categories.contains { $0.id == category.id && !($0.promotions?.isEmpty ?? false) }
        } else {
            return dayPromotion.categories.contains { !($0.promotions?.isEmpty ?? false) }
        }
    }
    
    func loadPromotionsForDate(_ date: Date) {
        let dateString = dateFormatter.string(from: date)
        if let index = days.firstIndex(where: { $0.date == dateString }) {
            selectedDayIndex = index
            selectedDate = date
        } else {
            selectedDate = date
        }
    }

    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func resetToCurrentDay() {
        if let today = days.firstIndex(where: { Calendar.current.isDateInToday(dateFormatter.date(from: $0.date)!) }) {
            selectedDayIndex = today
            selectedDate = Date()
        }
    }

    // Nueva función para filtrar promociones
    func filteredPromotions(promotions: [Promotion]) -> [Promotion] {
        promotions.filter { promotion in
            let matchesCategory = selectedCategory == nil || promotion.categories?.contains { $0.name == selectedCategory?.name } ?? false
            return matchesCategory
        }
    }
}
