import SwiftUI

struct MerchantProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingAddPromotion = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Merchant: \(viewModel.user.name)")
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Button(action: {
                            showingAddPromotion = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }
                    .padding()
                    
                    Text("Mis Promociones")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(viewModel.merchantPromotions) { promotion in
                            NavigationLink(destination: PromotionDetailView(viewModel: PromotionDetailViewModel(promotion: promotion))) {
                                SimplePromotionCell(promotion: promotion)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Perfil Merchant")
            .navigationBarItems(trailing: Image(systemName: "briefcase"))
        }
        .sheet(isPresented: $showingAddPromotion) {
            AddPromotionView(viewModel: viewModel)
        }
    }
}

struct MerchantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MerchantProfileView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)))
    }
}
