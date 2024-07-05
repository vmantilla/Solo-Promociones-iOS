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

    private let promotionService: PromotionServiceProtocol

    init(promotionService: PromotionServiceProtocol = PromotionService()) {
        self.promotionService = promotionService
        Task {
            await loadPromotions()
        }
    }

    @MainActor
    func loadPromotions() async {
        do {
            self.days = try await promotionService.fetchDailyPromotions()
            if let today = days.firstIndex(where: {
                calendar.isDateInToday(dateFormatter.date(from: $0.date)!)
            }) {
                selectedDayIndex = today
            }
            loadCategories()
        } catch {
            print("Failed to load promotions: \(error)")
        }
    }
    
    func loadCategories() {
        let allCategories = days.flatMap { $0.categories }
        self.categories = allCategories.reduce(into: [Category]()) { result, category in
            if !result.contains(where: { $0.id == category.id }) {
                result.append(category)
            }
        }.sorted(by: { $0.id < $1.id })
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

    func filteredPromotions(promotions: [Promotion]) -> [Promotion] {
        promotions.filter { promotion in
            let matchesCategory = selectedCategory == nil || promotion.categories?.contains { $0.name == selectedCategory?.name } ?? false
            return matchesCategory
        }
    }
}
