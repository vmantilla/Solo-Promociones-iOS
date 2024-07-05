import Foundation
import Combine
import SwiftUI

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    var selectedCity: String { get set }
    var selectedCategory: Category? { get set }
    var sections: [PromotionSection] { get }
    var categories: [Category] { get }
    var cities: [City] { get }
    var showError: Bool { get set }
    var errorMessage: String { get set }
    var isLoading: Bool { get set }
    func loadPromotions() async
    func loadCities() async
    func refreshCities() async
    func searchPromotions(query: String) -> [Promotion]
    func refreshData() async
}

@MainActor
class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published var sections: [PromotionSection] = []
    @Published var categories: [Category] = []
    @Published var cities: [City] = []
    @Published var selectedCategory: Category?
    @Published var selectedCity: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    private let promotionService: PromotionServiceProtocol
    private let cityService: CityServiceProtocol
    private let categoryService: CategoryServiceProtocol

    init(promotionService: PromotionServiceProtocol = PromotionService(), cityService: CityServiceProtocol = CityService(), categoryService: CategoryServiceProtocol = CategoryService()) {
        self.promotionService = promotionService
        self.cityService = cityService
        self.categoryService = categoryService
        Task {
            await refreshData()
        }
        loadSelectedCity()
        loadSelectedCategory()
    }

    func loadPromotions() async {
        do {
            let jsonData = try await promotionService.fetchPromotions()
            await MainActor.run {
                self.sections = jsonData.sections
            }
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las promociones. Estamos trabajando para solucionarlo."
            }
        }
    }

    func searchPromotions(query: String) -> [Promotion] {
        sections.flatMap { $0.promotions }.filter { promotion in
            (query.isEmpty || promotion.title.localizedCaseInsensitiveContains(query))
        }
    }

    func refreshData() async {
        isLoading = true
        await loadPromotions()
        await loadCities()
        await loadCategories()
        isLoading = false
    }
}

// Cities
extension HomeViewModel {
    func loadCities() async {
        let localCities = cityService.loadCitiesLocally()
        await MainActor.run {
            if !localCities.isEmpty {
                self.cities = localCities
                if selectedCity.isEmpty, let firstCity = localCities.first {
                    self.selectedCity = firstCity.name
                }
            } else {
                Task {
                    await self.refreshCities()
                }
            }
        }
    }

    func refreshCities() async {
        do {
            let remoteCities = try await cityService.fetchCities()
            await MainActor.run {
                self.cities = remoteCities
                if selectedCity.isEmpty, let firstCity = remoteCities.first {
                    self.selectedCity = firstCity.name
                }
            }
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las ciudades. Estamos trabajando para solucionarlo."
            }
        }
    }

    func loadSelectedCity() {
        if let city = cityService.loadSelectedCity() {
            selectedCity = city
        }
    }
}

// Categories
extension HomeViewModel {
    func loadCategories() async {
        do {
            let fetchedCategories = try await categoryService.fetchCategories()
            await MainActor.run {
                self.categories = fetchedCategories
            }
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las categorías. Estamos trabajando para solucionarlo."
            }
        }
    }

    func loadSelectedCategory() {
        if let category = categoryService.loadSelectedCategory() {
            selectedCategory = category
        }
    }

    func saveSelectedCategory(_ category: Category?) {
        categoryService.saveSelectedCategory(category: category)
        selectedCategory = category
    }
}
