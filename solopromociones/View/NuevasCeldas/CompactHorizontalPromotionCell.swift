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
        HStack(spacing: 12) {
            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(promotion.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(promotion.validUntil)
                    .font(.caption2)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Text("Ver")
                .font(.footnote)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
