import SwiftUI

struct MerchantProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingAddPromotion = false
    @State private var showingEditProfile = false
    let maxPromotionSpots = 16
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) { // Increased spacing
                // Header
                ZStack(alignment: .bottomLeading) {
                    if let backgroundImage = viewModel.backgroundImage {
                        Image(uiImage: backgroundImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                    }
                    
                    HStack(alignment: .bottom) {
                        if let profileImage = viewModel.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.user.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Merchant")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        
                        Spacer()
                        
                        Button(action: {
                            showingEditProfile = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .frame(height: 250)
                
                // Promotions
                Text("Mis Promociones")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(0..<maxPromotionSpots, id: \.self) { index in
                        if index < viewModel.merchantPromotions.count {
                            NavigationLink(destination: PromotionDetailView(viewModel: PromotionDetailViewModel(promotion: viewModel.merchantPromotions[index]))) {
                                PromotionCell(promotion: viewModel.merchantPromotions[index])
                            }
                        } else {
                            AddPromotionCell {
                                showingAddPromotion = true
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Perfil Merchant")
        .navigationBarItems(trailing: Image(systemName: "briefcase"))
        .sheet(isPresented: $showingAddPromotion) {
            AddPromotionView(profileViewModel: viewModel)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
    }
}

struct MerchantProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MerchantProfileView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)))
    }
}
