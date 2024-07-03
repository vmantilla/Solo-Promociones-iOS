import SwiftUI

struct MerchantProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingAddPromotion = false
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var selectedPromotion: Promotion?
    @State private var scrollOffset: CGFloat = 0
    @State private var showingEditPromotion = false
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
            }
            .frame(height: 0)
            
            VStack(spacing: 20) {
                // Profile Header
                HStack(alignment: .top, spacing: 20) {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(viewModel.user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Merchant")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Stats
                HStack {
                    Spacer()
                    StatView(title: "Promociones", value: "\(viewModel.merchantPromotions.count)")
                    Spacer()
                    StatView(title: "Calificación", value: "4.5")
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Promotions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mis Promociones")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(0..<viewModel.availableSpots, id: \.self) { index in
                            if index < viewModel.merchantPromotions.count {
                                PromotionCell(promotion: viewModel.merchantPromotions[index])
                                    .onTapGesture {
                                        selectedPromotion = viewModel.merchantPromotions[index]
                                        showingEditPromotion = true
                                    }
                            } else {
                                AddPromotionCell {
                                    showingAddPromotion = true
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(scrollOffset < -50 ? viewModel.user.name : "")
        .sheet(isPresented: $showingAddPromotion) {
            AddPromotionView(profileViewModel: viewModel)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingEditPromotion) {
            if let promotion = selectedPromotion {
                let promotionDetailViewModel = PromotionEditDetailViewModel(promotion: promotion)
                EditPromotionView(viewModel: promotionDetailViewModel)
            }
        }
    }
}
