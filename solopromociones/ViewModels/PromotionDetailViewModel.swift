import SwiftUI
import Combine

@MainActor
class PromotionDetailViewModel: ObservableObject {
    @Published var promotion: PromotionDetail?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isFavorite = false
    
    private let promotionService: PromotionServiceProtocol
    private var promotionId: String
    
    init(promotionId: String, promotionService: PromotionServiceProtocol = PromotionService()) {
        self.promotionId = promotionId
        self.promotionService = promotionService
        Task {
            await loadPromotionDetail()
        }
    }
    
    func loadPromotionDetail() async {
        isLoading = true
        do {
            let promotionDetail = try await promotionService.fetchPromotionDetail(id: promotionId)
            self.promotion = promotionDetail
            self.isFavorite = promotionDetail.isFavorite
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func toggleFavorite() async {
        guard var promotion = promotion else { return }
        isFavorite.toggle()
        promotion.isFavorite = isFavorite
        
        do {
            try await promotionService.updateFavoriteStatus(promotionId: promotion.id, isFavorite: isFavorite)
        } catch {
            print("Error updating favorite status: \(error)")
            // Revert the change if the update fails
            self.isFavorite.toggle()
        }
    }
    
    func openInMaps() {
        guard let promotion = promotion else { return }
        let latitude = promotion.merchant.latitude
        let longitude = promotion.merchant.longitude
        
        let coordinates = "\(latitude),\(longitude)"
        let name = promotion.merchant.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString: String
        if let url = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(url) {
            urlString = "comgooglemaps://?q=\(coordinates)(\(name))&zoom=14"
        } else {
            urlString = "https://www.google.com/maps/search/?api=1&query=\(coordinates)"
        }
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
