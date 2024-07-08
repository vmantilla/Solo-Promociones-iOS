import Foundation

struct API {
    static let baseURL = "https://solopromociones-041ae316142f.herokuapp.com/api/v1"
}

struct Endpoints {
    static let cities = "\(API.baseURL)/cities"
    static let anonymousUsers = "\(API.baseURL)/anonymous_users"
    static let categories = "\(API.baseURL)/categories"
}
