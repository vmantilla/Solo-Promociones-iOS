//
//  HighlightedConditionsPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 18/06/24.
//

import SwiftUI
import CachedAsyncImage

struct HighlightedConditionsPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
            Text(promotion.title)
                .font(.headline)
            Text(promotion.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Condiciones: \(promotion.conditions)")
                .font(.footnote)
                .foregroundColor(.red)
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}
