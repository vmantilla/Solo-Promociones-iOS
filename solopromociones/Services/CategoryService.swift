import Foundation

protocol CategoryServiceProtocol {
    func fetchCategories() async throws -> [Category]
    func saveCategoriesLocally(categories: [Category])
    func loadCategoriesLocally() -> [Category]
    func saveSelectedCategory(category: Category?)
    func loadSelectedCategory() -> Category?
}

class CategoryService: CategoryServiceProtocol {
    private let categoriesKey = "savedCategories"
    private let selectedCategoryKey = "selectedCategory"
    
    func fetchCategories() async throws -> [Category] {
        do {
            let remoteCategories = try await fetchRemoteCategories()
            saveCategoriesLocally(categories: remoteCategories)
            return remoteCategories
        } catch {
            let localCategories = loadCategoriesLocally()
            if !localCategories.isEmpty {
                return localCategories
            } else {
                return loadCategoriesFromJSON()
            }
        }
    }
    
    func fetchRemoteCategories() async throws -> [Category] {
        guard let url = URL(string: Endpoints.categories) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let categories = try decoder.decode([Category].self, from: data)
        
        saveCategoriesLocally(categories: categories)
        
        return categories
    }
    
    func saveCategoriesLocally(categories: [Category]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    func loadCategoriesLocally() -> [Category] {
        if let savedCategories = UserDefaults.standard.data(forKey: categoriesKey) {
            let decoder = JSONDecoder()
            if let loadedCategories = try? decoder.decode([Category].self, from: savedCategories) {
                return loadedCategories
            }
        }
        return []
    }
    
    func saveSelectedCategory(category: Category?) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(category) {
            UserDefaults.standard.set(encoded, forKey: selectedCategoryKey)
        }
    }
    
    func loadSelectedCategory() -> Category? {
        if let savedCategory = UserDefaults.standard.data(forKey: selectedCategoryKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(Category.self, from: savedCategory)
        }
        return nil
    }
    
    private func loadCategoriesFromJSON() -> [Category] {
        if let url = Bundle.main.url(forResource: "categories", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode([Category].self, from: data)
            } catch {
                print("Error loading categories from JSON: \(error)")
            }
        }
        return []
    }
}
