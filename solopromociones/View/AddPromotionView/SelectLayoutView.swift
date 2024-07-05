import SwiftUI

struct SelectLayoutView: View {
    @ObservedObject var viewModel: AddPromotionViewModel
    @State private var selectedLayout: CellLayoutType = .standard
    @State private var showConfirmationView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Seleccionar Layout")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            PreviewCell(
                promotion: Promotion(
                    id: UUID().uuidString,
                    title: viewModel.title,
                    description: viewModel.description,
                    validUntil: viewModel.endDate.formatted(date: .abbreviated, time: .omitted),
                    imageURL: viewModel.imageURL,
                    conditions: viewModel.conditions, cellType: .standard
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
                showConfirmationView = true
            }) {
                Text("Siguiente")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom)
            .background(
                NavigationLink(
                    destination: ConfirmationView(viewModel: ConfirmationViewModel(addPromotionViewModel: viewModel)),
                    isActive: $showConfirmationView
                ) {
                    EmptyView()
                }
            )
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Back")
        })
    }
}

struct SelectLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectLayoutView(
                viewModel: AddPromotionViewModel(
                    profileViewModel: ProfileViewModel()
                )
            )
        }
    }
}
