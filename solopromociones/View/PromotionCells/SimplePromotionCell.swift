import SwiftUI
import CachedAsyncImage

struct SimplePromotionCell: View {
    let promotion: Promotion

    var body: some View {
        CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 150, height: 150)
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
