import SwiftUI
import CachedAsyncImage

struct StandardPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        NavigationLink(destination: PromotionDetailView(promotionId: "promo123")) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 10) {
                    CachedAsyncImage(url: URL(string: promotion.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.2)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(6)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(promotion.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemIndigo))
                        Text(promotion.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Válido hasta:")
                            .font(.caption2)
                        Text(promotion.validUntil)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text(promotion.conditions)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StandardPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StandardPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
        }
    }
}
