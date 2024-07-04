import Foundation
import Combine
import SwiftUI

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    var selectedCity: String { get set }
    var promotions: [Promotion] { get }
    var categories: [String] { get }
    var cities: [City] { get }
    var featuredPromotions: [Promotion] { get }
    var dailyDeals: [Promotion] { get }
    var nearbyPromotions: [Promotion] { get }
    var popularPromotions: [Promotion] { get }
    var showError: Bool { get }
    var errorMessage: String { get }
    func loadPromotions() async
    func loadCities() async
    func refreshCities() async
    func searchPromotions(query: String) -> [Promotion]
}

@MainActor
class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published var selectedCity: String = ""
    @Published private(set) var promotions: [Promotion] = []
    @Published private(set) var categories: [String] = []
    @Published private(set) var cities: [City] = []
    @Published private(set) var featuredPromotions: [Promotion] = []
    @Published private(set) var dailyDeals: [Promotion] = []
    @Published private(set) var nearbyPromotions: [Promotion] = []
    @Published private(set) var popularPromotions: [Promotion] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let promotionService: PromotionServiceProtocol
    private let cityService: CityServiceProtocol
    
    init(promotionService: PromotionServiceProtocol = PromotionService(), cityService: CityServiceProtocol = CityService()) {
        self.promotionService = promotionService
        self.cityService = cityService
        Task {
            await loadPromotions()
            await loadCities()
        }
        loadSelectedCity()
    }
    
    func loadPromotions() async {
        do {
            let jsonData = try await promotionService.fetchPromotions()
            await MainActor.run {
                self.promotions = jsonData.promotions
                self.categories = jsonData.categories
                
                // Asignar promociones a diferentes secciones
                self.featuredPromotions = Array(jsonData.promotions.prefix(5))
                self.dailyDeals = Array(jsonData.promotions.suffix(5))
                self.nearbyPromotions = Array(jsonData.promotions.shuffled().prefix(5))
                self.popularPromotions = Array(jsonData.promotions.shuffled().prefix(3))
            }
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las promociones. Estamos trabajando para solucionarlo."
            }
        }
    }
    
    func loadCities() async {
        let localCities = cityService.loadCitiesLocally()
        if !localCities.isEmpty {
            self.cities = localCities
            if selectedCity.isEmpty, let firstCity = localCities.first {
                self.selectedCity = firstCity.name
            }
        } else {
            await refreshCities()
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
    
    func searchPromotions(query: String) -> [Promotion] {
        promotions.filter { promotion in
            (query.isEmpty || promotion.title.localizedCaseInsensitiveContains(query))
        }
    }
}
