import Foundation
import Combine

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
    }
    
    func loadPromotions() async {
        do {
            let jsonData = try await promotionService.fetchPromotions()
            self.promotions = jsonData.promotions
            self.categories = jsonData.categories
            
            // Asignar promociones a diferentes secciones
            self.featuredPromotions = Array(jsonData.promotions.prefix(5))
            self.dailyDeals = Array(jsonData.promotions.suffix(5))
            self.nearbyPromotions = Array(jsonData.promotions.shuffled().prefix(5))
            self.popularPromotions = Array(jsonData.promotions.shuffled().prefix(3))
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las promociones. Estamos trabajando para solucionarlo."
            }
        }
    }
    
    func loadCities() async {
        do {
            let cities = try await cityService.fetchCities()
            self.cities = cities
            if let firstCity = cities.first {
                self.selectedCity = firstCity.name
            }
        } catch {
            await MainActor.run {
                self.showError = true
                self.errorMessage = "Ha ocurrido un error al cargar las ciudades. Estamos trabajando para solucionarlo."
            }
        }
    }
    
    func searchPromotions(query: String) -> [Promotion] {
        promotions.filter { promotion in
            (query.isEmpty || promotion.title.localizedCaseInsensitiveContains(query))
        }
    }
}
