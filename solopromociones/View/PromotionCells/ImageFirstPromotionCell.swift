// ImageFirstPromotionCell.swift
import SwiftUI
import CachedAsyncImage

struct ImageFirstPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        VStack(alignment: .leading) {
            Text(promotion.title)
                .font(.headline)
            CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            .shadow(radius: 5)

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
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}
