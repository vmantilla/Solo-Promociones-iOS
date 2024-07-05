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
