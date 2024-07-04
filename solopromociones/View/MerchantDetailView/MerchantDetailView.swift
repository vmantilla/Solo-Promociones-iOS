import SwiftUI
import CachedAsyncImage

struct MerchantDetailView: View {
    @StateObject private var viewModel: MerchantDetailViewModel
    @State private var currentImageIndex = 0
    
    init(merchantId: String) {
        _viewModel = StateObject(wrappedValue: MerchantDetailViewModel(merchantId: merchantId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    if let merchant = viewModel.merchant {
                        merchantContent(merchant)
                    } else if viewModel.isLoading {
                        ProgressView("Cargando información del comerciante...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func merchantContent(_ merchant: MerchantDetail) -> some View {
        imageCarousel(images: merchant.images)
        merchantInfo(merchant: merchant)
        merchantDescription(merchant: merchant)
        categoryTags(categories: merchant.categories)
        openingHours(merchant: merchant)
        locationInfo(merchant: merchant)
        contactInfo(merchant: merchant)
        socialMediaLinks(merchant: merchant)
        merchantPromotions(promotions: merchant.promotions)
    }
    
    private func imageCarousel(images: [String]) -> some View {
        TabView(selection: $currentImageIndex) {
            ForEach(images.indices, id: \.self) { index in
                CachedAsyncImage(url: URL(string: images[index])) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 200)
        .cornerRadius(10)
    }
    
    private func merchantInfo(merchant: MerchantDetail) -> some View {
        HStack {
            CachedAsyncImage(url: URL(string: merchant.logoURL)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle().fill(Color.gray.opacity(0.2))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(merchant.name).font(.headline)
                Text(merchant.mainCategory).font(.caption).foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: viewModel.toggleFavorite) {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorite ? .red : .gray)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func merchantDescription(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sobre nosotros")
                .font(.subheadline)
                .fontWeight(.medium)
            Text(merchant.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func categoryTags(categories: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.random.opacity(0.2))
                        .foregroundColor(Color.random.opacity(0.8))
                        .cornerRadius(12)
                }
            }
        }
    }
    
    private func openingHours(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Horas de apertura").font(.subheadline).fontWeight(.medium)
            ForEach(merchant.openingHours, id: \.day) { hours in
                HStack {
                    Text(hours.day).font(.caption)
                    Spacer()
                    Text("\(hours.openingTime) - \(hours.closingTime)").font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func locationInfo(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ubicación").font(.subheadline).fontWeight(.medium)
            Text(merchant.address).font(.caption).foregroundColor(.secondary)
            
            Button(action: viewModel.openInMaps) {
                Text("Ver en el mapa")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func contactInfo(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Información de contacto").font(.subheadline).fontWeight(.medium)
            
            if let phoneNumber = merchant.phoneNumber {
                HStack {
                    Image(systemName: "phone")
                    Text(phoneNumber)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            if let email = merchant.email {
                HStack {
                    Image(systemName: "envelope")
                    Text(email)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            if let website = merchant.website {
                HStack {
                    Image(systemName: "globe")
                    Text(website)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func socialMediaLinks(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(spacing: 8) {
                if let facebookURL = merchant.facebookURL {
                    socialMediaButton(
                        icon: "f.circle.fill",
                        text: "Síguenos en Facebook",
                        color: .blue
                    ) {
                        openURL(facebookURL)
                    }
                }
                
                if let instagramURL = merchant.instagramURL {
                    socialMediaButton(
                        icon: "camera.circle.fill",
                        text: "Síguenos en Instagram",
                        color: .purple
                    ) {
                        openURL(instagramURL)
                    }
                }
                
                if let whatsappNumber = merchant.whatsappNumber {
                    socialMediaButton(
                        icon: "phone.circle.fill",
                        text: "Contáctanos por WhatsApp",
                        color: .green
                    ) {
                        openWhatsApp(whatsappNumber)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func socialMediaButton(icon: String, text: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(color.opacity(0.8))
                    .clipShape(Circle())
                
                Text(text)
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
    }
    
    private func merchantPromotions(promotions: [MerchantPromotion]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Otras Promociones")
                .font(.subheadline)
                .fontWeight(.medium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(promotions) { promotion in
                        VStack(spacing: 4) {
                            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(6)
                            
                            Text(promotion.title)
                                .font(.caption2)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openWhatsApp(_ number: String) {
        let urlString = "https://wa.me/\(number)"
        openURL(urlString)
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct MerchantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MerchantDetailView(merchantId: "merchant456")
    }
}
