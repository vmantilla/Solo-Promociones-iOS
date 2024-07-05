//
//  PromotionCard.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI
import CachedAsyncImage

struct PromotionCard: View {
    let promotion: Promotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(8)
            
            Text(promotion.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text(promotion.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
