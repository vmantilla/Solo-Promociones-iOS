import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isMerchant: Bool
    @Published var merchantPromotions: [Promotion] = []
    @Published var profileImage: UIImage?
    @Published var backgroundImage: UIImage?
    
    init(user: User) {
        self.user = user
        self.isMerchant = user.isMerchant
        if user.isMerchant {
            loadPromotions()
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
            if let merchant = usersContainer.users.first(where: { $0.id == user.id }) {
                self.merchantPromotions = merchant.promotions ?? []
            }
        } catch {
            print("Error loading promotions: \(error)")
        }
    }
    
    func toggleMerchantStatus() {
        self.isMerchant.toggle()
        self.user.isMerchant = self.isMerchant
        if self.isMerchant {
            loadPromotions()
        } else {
            self.merchantPromotions = []
        }
    }
    
    func addPromotion(_ promotion: Promotion) {
        merchantPromotions.append(promotion)
    }
    
    func updateProfile(name: String, profileImage: UIImage?, backgroundImage: UIImage?) {
            self.user.name = name
            self.profileImage = profileImage
            self.backgroundImage = backgroundImage
            // Implement actual update logic here (e.g., API calls)
        }
}
