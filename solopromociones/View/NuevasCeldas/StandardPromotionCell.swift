//
//  StandardPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI

import SwiftUI
import CachedAsyncImage

struct StandardPromotionCell: View {
    let promotion: Promotion

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                CachedAsyncImage(url: URL(string: promotion.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(promotion.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemIndigo))
                    Text(promotion.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Válido hasta:")
                        .font(.caption)
                    Text(promotion.validUntil)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                Spacer()
                Text(promotion.conditions)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
struct StandardPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        StandardPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
