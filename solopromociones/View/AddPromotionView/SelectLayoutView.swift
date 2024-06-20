import SwiftUI

struct SelectLayoutView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var title: String
    @Binding var description: String
    @Binding var validUntil: String
    @Binding var imageURL: String
    @Binding var conditions: String
    @Binding var recurrence: RecurrenceType
    @Binding var selectedImage: UIImage?
    @State private var selectedLayout: CellLayoutType = .standard
    @Binding var showSelectLayoutView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Seleccionar Layout")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            PreviewCell(
                promotion: Promotion(
                    id: UUID().uuidString,
                    title: title,
                    description: description,
                    validUntil: validUntil,
                    imageURL: imageURL,
                    conditions: conditions
                ),
                layout: selectedLayout
            )
            .padding(.top)
            
            Spacer()
            
            Picker("Seleccionar Layout", selection: $selectedLayout) {
                ForEach(CellLayoutType.allCases) { layout in
                    Text(layout.description).tag(layout)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxHeight: 150)
            .clipped()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding()
            
            Button(action: {
                let newPromotion = Promotion(
                    id: UUID().uuidString,
                    title: title,
                    description: description,
                    validUntil: validUntil,
                    imageURL: imageURL,
                    conditions: conditions
                )
                viewModel.addPromotion(newPromotion)
                showSelectLayoutView = false
            }) {
                Text("Finalizar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            showSelectLayoutView = false
        }) {
            Text("Back")
        })
    }
}

struct SelectLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectLayoutView(
                viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)),
                title: .constant("Título de Ejemplo"),
                description: .constant("Descripción de Ejemplo"),
                validUntil: .constant("30/06/2024"),
                imageURL: .constant("https://dummyimage.com/600x400/000/fff"),
                conditions: .constant("Condiciones de Ejemplo"),
                recurrence: .constant(.none),
                selectedImage: .constant(nil),
                showSelectLayoutView: .constant(true)
            )
        }
    }
}
