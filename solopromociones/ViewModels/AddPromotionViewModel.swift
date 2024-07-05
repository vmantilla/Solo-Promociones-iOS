import SwiftUI
import PhotosUI
import CachedAsyncImage

enum RecurrenceType: String, CaseIterable, Identifiable {
    case none = "None"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .none:
            return "Ninguna"
        case .daily:
            return "Diaria"
        case .weekly:
            return "Semanal"
        case .monthly:
            return "Mensual"
        case .yearly:
            return "Anual"
        }
    }
}

enum CellLayoutType: String, CaseIterable, Identifiable {
    case standard
    case minimalist
    case boldTitle
    case imageFirst
    case overlayText
    case cardStyle
    case highlightedConditions
    case bannerStyle
    case splitView
    case rounded
    case detailed
    case imageBackground
    case circularImage
    case horizontal
    case compact
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .standard:
            return "Standard"
        case .minimalist:
            return "Minimalista"
        case .boldTitle:
            return "Título Negrita"
        case .imageFirst:
            return "Imagen Primero"
        case .overlayText:
            return "Texto Superpuesto"
        case .cardStyle:
            return "Estilo Tarjeta"
        case .highlightedConditions:
            return "Condiciones Resaltadas"
        case .bannerStyle:
            return "Estilo Banner"
        case .splitView:
            return "Vista Dividida"
        case .rounded:
            return "Redondeada"
        case .detailed:
            return "Detallada"
        case .imageBackground:
            return "Fondo de Imagen"
        case .circularImage:
            return "Imagen Circular"
        case .horizontal:
            return "Horizontal"
        case .compact:
            return "Compacta"
        }
    }
}

class AddPromotionViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var imageURL = ""
    @Published var conditions = ""
    @Published var recurrence = RecurrenceType.none
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showSelectLayoutView = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    public let profileViewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    func validateAndProceed() {
        if title.isEmpty {
            showAlert(with: "Por favor, ingrese un título.")
            return
        }
        
        if description.isEmpty {
            showAlert(with: "Por favor, ingrese una descripción.")
            return
        }
        
        if conditions.isEmpty {
            showAlert(with: "Por favor, ingrese las condiciones.")
            return
        }
        
        if selectedImage == nil && imageURL.isEmpty {
            showAlert(with: "Por favor, seleccione una imagen o ingrese una URL de imagen.")
            return
        }
        
        if endDate < startDate {
            showAlert(with: "La fecha de fin debe ser posterior a la fecha de inicio.")
            return
        }
        
        showSelectLayoutView = true
    }
    
    private func showAlert(with message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func saveImageToDocuments(image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            return nil
        }
    }
    
    func addPromotion() {
        let newPromotion = Promotion(
            id: UUID().uuidString,
            title: title,
            description: description,
            validUntil: endDate.formatted(date: .abbreviated, time: .omitted),
            imageURL: selectedImage != nil ? saveImageToDocuments(image: selectedImage!)?.absoluteString ?? imageURL : imageURL,
            conditions: conditions, cellType: .standard
        )
        profileViewModel.addPromotion(newPromotion)
    }
}
