//
//  CircularImagePromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 18/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CircularImagePromotionCell: View {
    let promotion: Promotion

    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 80, height: 80)
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



struct CircularImagePromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        CircularImagePromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
