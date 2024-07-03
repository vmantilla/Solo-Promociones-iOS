import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var isMerchant: Bool = false
    @Published var merchantPromotions: [Promotion] = []
    @Published var profileImage: UIImage?
    @Published var backgroundImage: UIImage?
    @Published var availableSpots: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        // Aquí implementarías la lógica real para verificar si el usuario está autenticado
        // Por ahora, simularemos esto con un valor hardcodeado
        isAuthenticated = false
        user = nil
    }
    
    func authenticateUser(phoneNumber: String, verificationCode: String, completion: @escaping (Bool) -> Void) {
        // Aquí implementarías la lógica de autenticación real
        // Por ahora, simularemos una autenticación exitosa
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isAuthenticated = true
            self.user = User(id: "1", name: "Usuario Ejemplo", email: "usuario@ejemplo.com", isMerchant: false)
            self.isMerchant = self.user?.isMerchant ?? false
            if self.isMerchant {
                self.loadPromotions()
            }
            completion(true)
        }
    }
    
    private func loadPromotions() {
        guard let url = Bundle.main.url(forResource: "merchant_promotions", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let usersContainer = try decoder.decode(UsersContainer.self, from: data)
            if let merchant = usersContainer.users.first(where: { $0.id == user?.id }) {
                self.merchantPromotions = merchant.promotions ?? []
            }
        } catch {
            print("Error loading promotions: \(error)")
        }
    }
    
    func toggleMerchantStatus() {
        isMerchant.toggle()
        user?.isMerchant = isMerchant
        if isMerchant {
            loadPromotions()
        } else {
            merchantPromotions = []
        }
    }
    
    func convertToMerchant(with spots: Int) {
        isMerchant = true
        user?.isMerchant = true
        availableSpots = spots
        loadPromotions()
    }

    func addPromotion(_ promotion: Promotion) {
        if merchantPromotions.count < availableSpots {
            merchantPromotions.append(promotion)
        }
    }
    
    func updateProfile(name: String, profileImage: UIImage?, backgroundImage: UIImage?) {
        user?.name = name
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        // Implement actual update logic here (e.g., API calls)
    }
    
    func signOut() {
        isAuthenticated = false
        user = nil
        isMerchant = false
        merchantPromotions = []
        profileImage = nil
        backgroundImage = nil
        availableSpots = 0
    }
}
