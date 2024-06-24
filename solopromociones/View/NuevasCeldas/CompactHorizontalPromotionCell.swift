//
//  CompactHorizontalPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CompactHorizontalPromotionCell: View {
    let promotion: Promotion
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(promotion.title)
                    .font(.headline)
                Text(promotion.validUntil)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Text("Ver")
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CompactHorizontalPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        CompactHorizontalPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
