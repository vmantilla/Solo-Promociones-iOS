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
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    if let promotion = viewModel.promotion {
                        promotionContent(promotion)
                    } else if viewModel.isLoading {
                        ProgressView("Cargando promoción...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadPromotionDetail()
        }
    }
    
    @ViewBuilder
    private func promotionContent(_ promotion: PromotionDetail) -> some View {
        imageCarousel(images: promotion.images)
        merchantInfo(merchant: promotion.merchant)
        promotionDetails(promotion)
        locationInfo(merchant: promotion.merchant)
        otherPromotions(merchant: promotion.merchant, promotions: promotion.otherPromotions)
        usePromotionButton()
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
        .frame(height: 250)
        .cornerRadius(12)
    }
    
    private func merchantInfo(merchant: MerchantDetail) -> some View {
        HStack {
            CachedAsyncImage(url: URL(string: merchant.logoURL)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle().fill(Color.gray)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(merchant.name).font(.headline)
                Text(merchant.category).font(.subheadline).foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: viewModel.toggleFavorite) {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func promotionDetails(_ promotion: PromotionDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(promotion.title).font(.title2).fontWeight(.bold)
            Text(promotion.description).font(.body)
            HStack {
                Image(systemName: "calendar")
                Text("Válido hasta: \(promotion.validUntil)")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text("Condiciones:").font(.headline)
            Text(promotion.conditions).font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func locationInfo(merchant: MerchantDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ubicación").font(.headline)
            Text(merchant.address).font(.subheadline)
            
            Button(action: viewModel.openInMaps) {
                Text("Ver en el mapa")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func otherPromotions(merchant: MerchantDetail, promotions: [PromotionSummary]) -> some View {
        VStack(alignment: .leading) {
            Text("Más promociones de \(merchant.name)")
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(promotions) { promotion in
                        VStack {
                            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            
                            Text(promotion.title)
                                .font(.caption)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 100)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func usePromotionButton() -> some View {
        Button(action: viewModel.usePromotion) {
            Text("Usar Promoción")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
}
