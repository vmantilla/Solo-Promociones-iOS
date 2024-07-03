import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var currentUser: User?
    @Published var authToken: String?
    
    private init() {}
    
    func login(user: User, token: String) {
        self.currentUser = user
        self.authToken = token
        saveToUserDefaults()
    }
    
    func logout() {
        self.currentUser = nil
        self.authToken = nil
        clearUserDefaults()
    }
    
    func isLoggedIn() -> Bool {
        return currentUser != nil && authToken != nil
    }
    
    private func saveToUserDefaults() {
        if let encodedUser = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(encodedUser, forKey: "currentUser")
        }
        UserDefaults.standard.set(authToken, forKey: "authToken")
    }
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    func loadFromUserDefaults() {
        if let savedUser = UserDefaults.standard.object(forKey: "currentUser") as? Data,
           let decodedUser = try? JSONDecoder().decode(User.self, from: savedUser) {
            self.currentUser = decodedUser
        }
        self.authToken = UserDefaults.standard.string(forKey: "authToken")
    }
}
