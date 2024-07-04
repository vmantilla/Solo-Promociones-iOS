import SwiftUI
import CachedAsyncImage

struct PromotionDetailView: View {
    @StateObject private var viewModel: PromotionDetailViewModel
    @State private var currentImageIndex = 0
    
    init(promotionId: String) {
        _viewModel = StateObject(wrappedValue: PromotionDetailViewModel(promotionId: promotionId))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    if let promotion = viewModel.promotion {
                        promotionContent(promotion)
                    } else if viewModel.isLoading {
                        ProgressView("Cargando promoción...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.loadPromotionDetail()
            }
        }
    }
    
    @ViewBuilder
    private func promotionContent(_ promotion: PromotionDetail) -> some View {
        imageCarousel(images: promotion.images)
        merchantInfo(merchant: promotion.merchant)
        promotionDetails(promotion)
        locationInfo(merchant: promotion.merchant)
        otherPromotions(merchant: promotion.merchant, promotions: promotion.otherPromotions)
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
        .cornerRadius(8)
    }
    
    private func merchantInfo(merchant: MerchantDetail) -> some View {
        NavigationLink(destination: MerchantDetailView(merchantId: merchant.id)) {
            HStack {
                CachedAsyncImage(url: URL(string: merchant.logoURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(merchant.name).font(.subheadline).fontWeight(.medium)
                    Text(merchant.category).font(.caption).foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.toggleFavorite()
                    }
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
    
    private func promotionDetails(_ promotion: PromotionDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(promotion.title).font(.headline).fontWeight(.medium)
            Text(promotion.description).font(.subheadline).foregroundColor(.secondary)
            HStack {
                Image(systemName: "calendar")
                Text("Válido hasta: \(promotion.validUntil)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Text("Condiciones:").font(.subheadline).fontWeight(.medium)
            Text(promotion.conditions).font(.caption).foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
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
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    private func otherPromotions(merchant: MerchantDetail, promotions: [PromotionSummary]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Más promociones de \(merchant.name)")
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
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
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
