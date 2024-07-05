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
