import Foundation

struct API {
    static let baseURL = "http://localhost:3001/api/v1"
}

struct Endpoints {
    static let cities = "\(API.baseURL)/cities"
    static let anonymousUsers = "\(API.baseURL)/anonymous_users"
    static let categories = "\(API.baseURL)/categories"
}
