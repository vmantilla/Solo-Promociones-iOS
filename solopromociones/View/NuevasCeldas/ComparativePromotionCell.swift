//
//  ComparativePromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct ComparativePromotionCell: View {
    let promotion1: Promotion
    let promotion2: Promotion
    
    var body: some View {
        HStack {
            VStack {
                CachedAsyncImage(url: URL(string: promotion1.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                
                Text(promotion1.title)
                    .font(.caption)
                    .lineLimit(2)
            }
            
            Divider()
            
            VStack {
                CachedAsyncImage(url: URL(string: promotion2.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                
                Text(promotion2.title)
                    .font(.caption)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ComparativePromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        ComparativePromotionCell(promotion1: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."), promotion2: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
