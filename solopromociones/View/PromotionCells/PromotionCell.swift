import SwiftUI
import CachedAsyncImage

struct PromotionCell: View {
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
                        .frame(height: 150)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            .shadow(radius: 5)

            Text(promotion.title)
                .font(.headline)
                .padding(.top, 5)
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
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct PromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
