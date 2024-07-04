import Foundation

protocol CityServiceProtocol {
    func fetchCities() async throws -> [City]
    func saveCitiesLocally(cities: [City])
    func loadCitiesLocally() -> [City]
    func saveSelectedCity(city: String)
    func loadSelectedCity() -> String?
}

class CityService: CityServiceProtocol {
    private let citiesKey = "savedCities"
    private let selectedCityKey = "selectedCity"
    
    func fetchCities() async throws -> [City] {
        do {
            let remoteCities = try await fetchRemoteCities()
            saveCitiesLocally(cities: remoteCities)
            return remoteCities
        } catch {
            let localCities = loadCitiesLocally()
            if !localCities.isEmpty {
                return localCities
            } else {
                return loadCitiesFromJSON()
            }
        }
    }
    
    func fetchRemoteCities() async throws -> [City] {
        guard let url = URL(string: Endpoints.cities) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)  else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let cities = try decoder.decode([City].self, from: data)
        
        saveCitiesLocally(cities: cities)
        
        return cities
    }
    
    func saveCitiesLocally(cities: [City]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: citiesKey)
        }
    }
    
    func loadCitiesLocally() -> [City] {
        if let savedCities = UserDefaults.standard.data(forKey: citiesKey) {
            let decoder = JSONDecoder()
            if let loadedCities = try? decoder.decode([City].self, from: savedCities) {
                return loadedCities
            }
        }
        return []
    }
    
    func saveSelectedCity(city: String) {
        UserDefaults.standard.set(city, forKey: selectedCityKey)
    }
    
    func loadSelectedCity() -> String? {
        return UserDefaults.standard.string(forKey: selectedCityKey)
    }
    
    private func loadCitiesFromJSON() -> [City] {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                return try decoder.decode([City].self, from: data)
            } catch {
                print("Error loading cities from JSON: \(error)")
            }
        }
        return []
    }
}
