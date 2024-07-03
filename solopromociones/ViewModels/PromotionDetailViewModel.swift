import SwiftUI
import Combine

class PromotionDetailViewModel: ObservableObject {
    @Published var promotion: PromotionDetail?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isFavorite = false
    
    private var cancellables = Set<AnyCancellable>()
    private let promotionService: PromotionServiceProtocol
    private var promotionId: String
    
    init(promotionId: String, promotionService: PromotionServiceProtocol = PromotionService()) {
        self.promotionId = promotionId
        self.promotionService = promotionService
    }
    
    func loadPromotionDetail() {
        isLoading = true
        promotionService.fetchPromotionDetail(id: promotionId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] promotionDetail in
                self?.promotion = promotionDetail
                self?.isFavorite = promotionDetail.isFavorite
            }
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        guard var promotion = promotion else { return }
        isFavorite.toggle()
        promotion.isFavorite = isFavorite
        
        promotionService.updateFavoriteStatus(promotionId: promotion.id, isFavorite: isFavorite)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error updating favorite status: \(error)")
                    // Revert the change if the update fails
                    self.isFavorite.toggle()
                }
            } receiveValue: { _ in
                print("Favorite status updated successfully")
            }
            .store(in: &cancellables)
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

protocol PromotionServiceProtocol {
    func fetchPromotionDetail(id: String) -> AnyPublisher<PromotionDetail, Error>
    func updateFavoriteStatus(promotionId: String, isFavorite: Bool) -> AnyPublisher<Void, Error>
}

class PromotionService: PromotionServiceProtocol {
    func fetchPromotionDetail(id: String) -> AnyPublisher<PromotionDetail, Error> {
        // Implement the actual API call here
        // For now, we'll use a mock implementation
        return Future { promise in
            if let url = Bundle.main.url(forResource: "promotion_detail", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let promotionDetail = try decoder.decode(PromotionDetail.self, from: data)
                    promise(.success(promotionDetail))
                } catch {
                    promise(.failure(error))
                }
            } else {
                promise(.failure(NSError(domain: "PromotionService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Promotion detail not found"])))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateFavoriteStatus(promotionId: String, isFavorite: Bool) -> AnyPublisher<Void, Error> {
        // Implement the actual API call here
        // For now, we'll use a mock implementation
        return Future { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}

struct PromotionDetail: Codable {
    let id: String
    let title: String
    let description: String
    let validUntil: String
    let images: [String]
    let conditions: String
    var isFavorite: Bool
    let merchant: MerchantDetail
    let otherPromotions: [PromotionSummary]
}

struct MerchantDetail: Codable {
    let id: String
    let name: String
    let category: String
    let logoURL: String
    let latitude: Double
    let longitude: Double
    let address: String
    let phoneNumber: String?
    let email: String?
    let website: String?
    let facebookURL: String?
    let instagramURL: String?
    let whatsappNumber: String?
}

struct PromotionSummary: Codable, Identifiable {
    let id: String
    let title: String
    let imageURL: String
}
