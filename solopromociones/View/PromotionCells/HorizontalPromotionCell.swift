//
//  HorizontalPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 18/06/24.
//
import SwiftUI
import CachedAsyncImage

struct HorizontalPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 100)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(promotion.title)
                    .font(.headline)
                Text(promotion.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Válido hasta: \(promotion.validUntil)")
                    .font(.caption)
                Text("Condiciones: \(promotion.conditions)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}
