import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var viewModel: ConfirmationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                previewSection
                promotionSummarySection
                datesAndCostSection
                finalizeButton
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var headerSection: some View {
        Text("Confirmación de Promoción")
            .font(.system(size: 28, weight: .bold))
            .padding(.top)
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vista previa")
                .font(.headline)
            
            PreviewCell(
                promotion: Promotion(
                    id: UUID().uuidString,
                    title: viewModel.title,
                    description: viewModel.description,
                    validUntil: viewModel.validUntil,
                    imageURL: viewModel.imageURL,
                    conditions: viewModel.conditions
                ),
                layout: viewModel.selectedLayout
            )
            .padding(.vertical)
        }
    }
    
    private var promotionSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resumen de Promoción")
                .font(.headline)
            
            VStack(spacing: 12) {
                summaryRow(title: "Título", content: viewModel.title)
                summaryRow(title: "Descripción", content: viewModel.description)
                summaryRow(title: "Fecha fin", content: viewModel.validUntil)
                summaryRow(title: "Condiciones", content: viewModel.conditions)
                summaryRow(title: "Recurrencia", content: viewModel.recurrence.description)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func summaryRow(title: String, content: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(content)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
            
            Spacer()
        }
    }
    
    private var datesAndCostSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fechas y Costos")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Inicio:")
                    Spacer()
                    Text(viewModel.formatDate(date: viewModel.startDate))
                }
                HStack {
                    Text("Fin:")
                    Spacer()
                    Text(viewModel.formatDate(date: viewModel.endDate))
                }
                
                Divider()
                
                ForEach(viewModel.generatePromotionDates(), id: \.self) { date in
                    HStack {
                        Text(viewModel.formatDate(date: date))
                        Spacer()
                        Text("$10")
                    }
                }
                
                Divider()
                
                HStack {
                    Text("Costo total:")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.calculateTotalCost())
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var finalizeButton: some View {
        Button(action: {
            let newPromotion = Promotion(
                id: UUID().uuidString,
                title: viewModel.title,
                description: viewModel.description,
                validUntil: viewModel.validUntil,
                imageURL: viewModel.imageURL,
                conditions: viewModel.conditions
            )
            // Agregar la promoción a la vista de perfil
            // viewModel.addPromotion(newPromotion)
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Finalizar y Publicar")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.top)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Atrás")
            }
            .foregroundColor(.blue)
        }
    }
}
