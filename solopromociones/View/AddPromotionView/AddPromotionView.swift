import SwiftUI
import PhotosUI
import CachedAsyncImage

struct AddPromotionView: View {
    @StateObject private var viewModel: AddPromotionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(profileViewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: AddPromotionViewModel(profileViewModel: profileViewModel))
    }
    
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
                    navigationLink
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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
            TextField("Ej: 2x1 en Pizzas", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Descripción")
                .font(.headline)
            TextEditor(text: $viewModel.description)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            datePickerView(title: "Fecha de inicio", selection: $viewModel.startDate)
            datePickerView(title: "Fecha de fin", selection: $viewModel.endDate)
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
            TextEditor(text: $viewModel.conditions)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Imagen")
                .font(.headline)
            
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(10)
                    .overlay(
                        Button(action: { viewModel.showImagePicker.toggle() }) {
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
                Button(action: { viewModel.showImagePicker.toggle() }) {
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
                
                Text("o")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("URL de la imagen", text: $viewModel.imageURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    private var recurrenceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recurrencia")
                .font(.headline)
            Picker("Recurrencia", selection: $viewModel.recurrence) {
                ForEach(RecurrenceType.allCases) { recurrence in
                    Text(recurrence.description).tag(recurrence)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var nextButton: some View {
        Button(action: { viewModel.validateAndProceed() }) {
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
            destination: SelectLayoutView(viewModel: viewModel),
            isActive: $viewModel.showSelectLayoutView
        ) {
            EmptyView()
        }
    }
}
