import SwiftUI
import PhotosUI
import CachedAsyncImage

struct AddPromotionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var validUntil = ""
    @State private var imageURL = ""
    @State private var conditions = ""
    @State private var recurrence = RecurrenceType.none
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var showSelectLayoutView = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Nueva Promoción")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Título")
                            .font(.headline)
                        TextField("Título", text: $title)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Descripción")
                            .font(.headline)
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Válido hasta")
                            .font(.headline)
                        TextField("Válido hasta", text: $validUntil)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Condiciones")
                            .font(.headline)
                        TextEditor(text: $conditions)
                            .frame(height: 100)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Imagen")
                            .font(.headline)
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(10)
                                .onTapGesture {
                                    showImagePicker.toggle()
                                }
                        } else {
                            Button(action: {
                                showImagePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "photo.on.rectangle.angled")
                                    Text("Subir Imagen")
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        Text("o")
                            .font(.headline)
                            .padding(.vertical, 10)
                        
                        TextField("URL de la imagen", text: $imageURL)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recurrencia")
                            .font(.headline)
                        Picker("Recurrencia", selection: $recurrence) {
                            ForEach(RecurrenceType.allCases) { recurrence in
                                Text(recurrence.description).tag(recurrence)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    
                    Button(action: {
                        showSelectLayoutView = true
                    }) {
                        Text("Siguiente")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.vertical)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                    .background(
                        NavigationLink(destination: SelectLayoutView(viewModel: viewModel, title: $title, description: $description, validUntil: $validUntil, imageURL: $imageURL, conditions: $conditions, recurrence: $recurrence, selectedImage: $selectedImage, showSelectLayoutView: $showSelectLayoutView), isActive: $showSelectLayoutView) {
                            EmptyView()
                        }
                    )
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddPromotionView_Previews: PreviewProvider {
    static var previews: some View {
        AddPromotionView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)))
    }
}

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
