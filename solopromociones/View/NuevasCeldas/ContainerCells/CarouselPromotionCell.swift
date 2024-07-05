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
    let navigateToDetail: (Promotion) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ofertas Destacadas")
                .font(.subheadline)
                .fontWeight(.medium)

            TabView {
                ForEach(promotions) { promotion in
                    Button(action: {
                        navigateToDetail(promotion)
                    }) {
                        StandardPromotionCell(promotion: promotion)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}
