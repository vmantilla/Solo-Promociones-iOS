//
//  PromotionRow.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI

struct PromotionRow: View {
    let promotion: Promotion
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(promotion.title)
                    .font(.headline)
                Text("promotion.category")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}



struct PromotionRow_Previews: PreviewProvider {
    static var previews: some View {
        PromotionRow(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
