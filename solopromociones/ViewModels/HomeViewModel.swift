import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedCity = "Ámsterdam"
    @Published var promotions: [Promotion] = []
    @Published var categories: [String] = []
    @Published var cities: [City] = []
    
    init() {
        loadPromotions()
        loadCities()
    }
    
    func loadPromotions() {
        if let url = Bundle.main.url(forResource: "home", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PromotionData.self, from: data)
                self.promotions = jsonData.promotions
                self.categories = jsonData.categories
            } catch {
                print("Error loading promotions JSON data: \(error)")
            }
        }
    }
    
    func loadCities() {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.cities = try decoder.decode([City].self, from: data)
            } catch {
                print("Error loading cities JSON data: \(error)")
            }
        }
    }
}

struct PromotionData: Codable {
    let promotions: [Promotion]
    let categories: [String]
}
