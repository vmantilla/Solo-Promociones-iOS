import Foundation

protocol CityServiceProtocol {
    func fetchCities() async throws -> [City]
}

class CityService: CityServiceProtocol {
    func fetchCities() async throws -> [City] {
        guard let url = URL(string: Endpoints.cities) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([City].self, from: data)
    }
}
