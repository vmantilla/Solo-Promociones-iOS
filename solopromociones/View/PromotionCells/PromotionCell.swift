import SwiftUI
import CachedAsyncImage

struct PromotionCell: View {
    let promotion: Promotion
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: promotion.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(promotion.title)
                .font(.caption)
                .lineLimit(2)
        }
    }
}


struct PromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        PromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
