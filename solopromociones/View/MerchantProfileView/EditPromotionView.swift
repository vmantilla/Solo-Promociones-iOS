import SwiftUI

struct EditPromotionView: View {
    @ObservedObject var viewModel: PromotionEditDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var description: String
    @State private var validUntil: String
    @State private var imageURL: String
    @State private var conditions: String
    
    init(viewModel: PromotionEditDetailViewModel) {
        self.viewModel = viewModel
        _title = State(initialValue: viewModel.promotion.title)
        _description = State(initialValue: viewModel.promotion.description)
        _validUntil = State(initialValue: viewModel.promotion.validUntil)
        _imageURL = State(initialValue: viewModel.promotion.imageURL)
        _conditions = State(initialValue: viewModel.promotion.conditions)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Editar Promoción")
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
                    Text("URL de la imagen")
                        .font(.headline)
                    TextField("URL de la imagen", text: $imageURL)
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
                
                Button(action: {
                    viewModel.updatePromotion(title: title, description: description, validUntil: validUntil, imageURL: imageURL, conditions: conditions)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Guardar cambios")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.vertical)
                
                Button(action: {
                    viewModel.deletePromotion()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Eliminar Promoción")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.vertical)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditPromotionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPromotionView(
                viewModel: PromotionEditDetailViewModel(
                    promotion: Promotion(id: "1", title: "Oferta Especial", description: "Descripción de la oferta especial", validUntil: "30/07/2024", imageURL: "https://example.com/image.jpg", conditions: "Aplican restricciones")
                )
            )
        }
    }
}
