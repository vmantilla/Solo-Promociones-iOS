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
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    titleSection
                    descriptionSection
                    datesSection
                    conditionsSection
                    imageSection
                    recurrenceSection
                    nextButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .background(navigationLink)
        }
    }
    
    private var headerSection: some View {
        Text("Nueva Promoción")
            .font(.system(size: 28, weight: .bold))
            .padding(.top)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Título")
                .font(.headline)
            TextField("Ej: 2x1 en Pizzas", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Descripción")
                .font(.headline)
            TextEditor(text: $description)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            datePickerView(title: "Fecha de inicio", selection: $startDate)
            datePickerView(title: "Fecha de fin", selection: $endDate)
        }
    }
    
    private func datePickerView(title: String, selection: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            DatePicker(title, selection: selection, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
    
    private var conditionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Condiciones")
                .font(.headline)
            TextEditor(text: $conditions)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Imagen")
                .font(.headline)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .overlay(
                        Button(action: { showImagePicker.toggle() }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(8),
                        alignment: .topTrailing
                    )
            } else {
                Button(action: { showImagePicker.toggle() }) {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                        Text("Subir Imagen")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .foregroundColor(.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                }
            }
            
            Text("o")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            TextField("URL de la imagen", text: $imageURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var recurrenceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recurrencia")
                .font(.headline)
            Picker("Recurrencia", selection: $recurrence) {
                ForEach(RecurrenceType.allCases) { recurrence in
                    Text(recurrence.description).tag(recurrence)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var nextButton: some View {
        Button(action: { showSelectLayoutView = true }) {
            Text("Siguiente")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.top)
    }
    
    private var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var navigationLink: some View {
        NavigationLink(
            destination: SelectLayoutView(
                viewModel: viewModel,
                title: $title,
                description: $description,
                validUntil: $validUntil,
                imageURL: $imageURL,
                conditions: $conditions,
                recurrence: $recurrence,
                selectedImage: $selectedImage,
                showSelectLayoutView: $showSelectLayoutView,
                startDate: $startDate,
                endDate: $endDate
            ),
            isActive: $showSelectLayoutView
        ) {
            EmptyView()
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
