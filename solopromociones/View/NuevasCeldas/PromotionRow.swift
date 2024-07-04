//
//  PromotionRow.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI
import CachedAsyncImage

struct PromotionRow: View {
    let promotion: Promotion
    
    var body: some View {
        HStack(spacing: 10) {
            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(promotion.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("promotion.category")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}



struct PromotionRow_Previews: PreviewProvider {
    static var previews: some View {
        PromotionRow(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
