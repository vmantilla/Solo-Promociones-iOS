import Foundation
import Combine

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var currentUser: User?
    @Published var authToken: String?
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private init() {
        loadFromUserDefaults()
    }
    
    @MainActor
    func login(user: User, token: String) {
        self.currentUser = user
        self.authToken = token
        saveToUserDefaults()
    }
    
    @MainActor
    func logout() {
        self.currentUser = nil
        self.authToken = nil
        clearUserDefaults()
    }
    
    func isLoggedIn() -> Bool {
        return currentUser != nil && authToken != nil
    }
    
    private func saveToUserDefaults() {
        DispatchQueue.global(qos: .background).async {
            if let encodedUser = try? JSONEncoder().encode(self.currentUser) {
                UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                UserDefaults.standard.synchronize()
            }
            UserDefaults.standard.set(self.authToken, forKey: "authToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func clearUserDefaults() {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.removeObject(forKey: "currentUser")
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadFromUserDefaults() {
        DispatchQueue.global(qos: .background).async {
            if let savedUser = UserDefaults.standard.object(forKey: "currentUser") as? Data,
               let decodedUser = try? JSONDecoder().decode(User.self, from: savedUser) {
                Task { @MainActor in
                    self.currentUser = decodedUser
                }
            }
            Task { @MainActor in
                self.authToken = UserDefaults.standard.string(forKey: "authToken")
            }
        }
    }
    
    @MainActor
    func handleAuthenticationError(error: Error) {
        self.showError = true
        self.errorMessage = "Ha ocurrido un error durante la autenticación. Estamos trabajando para solucionarlo. Error: \(error.localizedDescription)"
    }
}
