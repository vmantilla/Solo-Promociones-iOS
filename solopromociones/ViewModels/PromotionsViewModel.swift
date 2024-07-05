import Combine
import Foundation

class PromotionsViewModel: ObservableObject {
    @Published var days: [DayPromotion] = []
    @Published var selectedDayIndex = 0
    @Published var selectedDate = Date()
    @Published var selectedCategory: Category? = nil
    @Published var categories: [Category] = []
    @Published var promotions: [Promotion] = []
    @Published var isLoading = false

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
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.days = try await promotionService.fetchDailyPromotions()
            if let today = days.firstIndex(where: {
                calendar.isDateInToday(dateFormatter.date(from: $0.date)!)
            }) {
                selectedDayIndex = today
                await loadPromotionsForCurrentSelection()
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

    @MainActor
    func loadPromotionsForDate(_ date: Date) async {
        isLoading = true
        defer { isLoading = false }
        
        let dateString = dateFormatter.string(from: date)
        if let index = days.firstIndex(where: { $0.date == dateString }) {
            selectedDayIndex = index
            selectedDate = date
            await loadPromotionsForCurrentSelection()
        } else {
            selectedDate = date
            // Aquí podrías cargar promociones para una fecha que no está en el arreglo de días
        }
    }

    func selectCategory(_ category: Category?) {
        selectedCategory = category
        Task {
            await loadPromotionsForCurrentSelection()
        }
    }
    
    @MainActor
    func resetToCurrentDay() async {
        isLoading = true
        defer { isLoading = false }
        
        if let today = days.firstIndex(where: { Calendar.current.isDateInToday(dateFormatter.date(from: $0.date)!) }) {
            selectedDayIndex = today
            selectedDate = Date()
            await loadPromotionsForCurrentSelection()
        }
    }
    
    @MainActor
    func loadPromotionsForCurrentSelection() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let selectedDay = days[safe: selectedDayIndex] else { return }
        
        if let selectedCategory = selectedCategory {
            promotions = selectedDay.categories
                .first(where: { $0.id == selectedCategory.id })?
                .promotions ?? []
        } else {
            promotions = selectedDay.categories.flatMap { $0.promotions ?? [] }
        }
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
}
