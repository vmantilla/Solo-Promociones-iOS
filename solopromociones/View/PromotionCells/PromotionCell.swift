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
