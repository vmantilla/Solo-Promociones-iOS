// RoundedPromotionCell.swift
import SwiftUI
import CachedAsyncImage

struct RoundedPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipShape(Circle())
                @unknown default:
                    EmptyView()
                }
            }
            .shadow(radius: 5)

            Text(promotion.title)
                .font(.headline)
            Text(promotion.description)
                .font(.subheadline)
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption)
            Text("Condiciones: \(promotion.conditions)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

struct RoundedPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        RoundedPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
