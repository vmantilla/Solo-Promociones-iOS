import Foundation

protocol AuthServiceProtocol {
    func authenticateAnonymously() async throws -> AnonymousAuthResponse
}

class AuthService: AuthServiceProtocol {
    func authenticateAnonymously() async throws -> AnonymousAuthResponse {
        guard let url = URL(string: "\(API.baseURL)/anonymous_users") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Bad server response with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw URLError(.badServerResponse)
        }

        guard !data.isEmpty else {
            print("Response data is empty")
            throw URLError(.zeroByteResource)
        }

        do {
            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AnonymousAuthResponse.self, from: data)
            print("Successfully authenticated anonymously: \(authResponse)")
            return authResponse
        } catch {
            print("Error decoding response data: \(error.localizedDescription)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw error
        }
    }
}
