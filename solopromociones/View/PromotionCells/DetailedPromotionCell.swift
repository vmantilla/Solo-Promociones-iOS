// DetailedPromotionCell.swift
import SwiftUI
import CachedAsyncImage

struct DetailedPromotionCell: View {
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

            Text(promotion.title)
                .font(.headline)
            Text(promotion.description)
                .font(.subheadline)
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption)
            Text("Condiciones: \(promotion.conditions)")
                .font(.footnote)
                .foregroundColor(.gray)
            Text("Detalles adicionales de la promoción que pueden incluir información específica sobre los términos y condiciones.")
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
