import Combine
import Foundation

class PromotionsViewModel: ObservableObject {
    @Published var days: [DayPromotion] = []
    @Published var selectedDayIndex = 0

    init() {
        loadPromotions()
    }

    func loadPromotions() {
        // Asumiendo que el archivo JSON se llama 'promotions.json' y está en el main bundle
        guard let url = Bundle.main.url(forResource: "promotions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load promotions data.")
            return
        }

        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode([DayPromotion].self, from: data) {
            self.days = jsonData
        }
    }
}
