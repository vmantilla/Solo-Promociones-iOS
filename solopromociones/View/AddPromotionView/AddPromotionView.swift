import SwiftUI

struct AddPromotionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var validUntil = ""
    @State private var imageURL = ""
    @State private var conditions = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                    let newPromotion = Promotion(id: UUID().uuidString, title: title, description: description, validUntil: validUntil, imageURL: imageURL, conditions: conditions)
                    viewModel.addPromotion(newPromotion)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Añadir Promoción")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
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

struct AddPromotionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddPromotionView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)))
        }
    }
}
