//
//  CarouselPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CarouselPromotionCell: View {
    let promotions: [Promotion]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ofertas Destacadas")
                .font(.headline)
            
            TabView {
                ForEach(promotions) { promotion in
                    StandardPromotionCell(promotion: promotion)
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

struct CarouselPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPromotionCell(promotions: [Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."), Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."), Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra.")])
    }
}
