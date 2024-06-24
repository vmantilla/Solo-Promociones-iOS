//
//  CollapsiblePromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CollapsiblePromotionCell: View {
    let promotion: Promotion
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(promotion.title)
                    .font(.headline)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                StandardPromotionCell(promotion: promotion)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CollapsiblePromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        CollapsiblePromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
