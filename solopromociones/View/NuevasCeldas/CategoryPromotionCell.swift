//
//  CategoryPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CategoryPromotionCell: View {
    let category: String
    let promotions: [Promotion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.subheadline)
                .fontWeight(.medium)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(promotions) { promotion in
                        VStack(spacing: 4) {
                            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(6)
                            
                            Text(promotion.title)
                                .font(.caption2)
                                .lineLimit(2)
                        }
                        .frame(width: 100)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

