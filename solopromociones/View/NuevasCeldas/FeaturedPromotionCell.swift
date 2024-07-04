//
//  FeaturedPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct FeaturedPromotionCell: View {
    let promotion: Promotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Promoción Destacada")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.orange)
            
            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 160)
            .cornerRadius(10)
            
            Text(promotion.title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(promotion.description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Válido hasta: \(promotion.validUntil)")
                .font(.caption2)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct FeaturedPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
