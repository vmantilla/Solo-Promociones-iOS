import Foundation

class PromotionEditDetailViewModel: ObservableObject {
    @Published var promotion: Promotion
    @Published var isEdited: Bool = false
    
    init(promotion: Promotion) {
        self.promotion = promotion
    }
    
    func updatePromotion(title: String, description: String, validUntil: String, imageURL: String, conditions: String) {
        promotion.title = title
        promotion.description = description
        promotion.validUntil = validUntil
        promotion.imageURL = imageURL
        promotion.conditions = conditions
        isEdited = true
    }
    
    func deletePromotion() {
        // Aquí debes implementar la lógica para eliminar la promoción
        // Por ejemplo, podrías enviar una solicitud a una API para eliminarla del servidor
        print("Promoción eliminada")
    }
}
