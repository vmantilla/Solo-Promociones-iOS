import Foundation

struct API {
    static let baseURL = "http://192.168.20.35:3001/api/v1"
}

struct Endpoints {
    static let cities = "\(API.baseURL)/cities"
    static let anonymousUsers = "\(API.baseURL)/anonymous_users"
    static let categories = "\(API.baseURL)/categories"
}
