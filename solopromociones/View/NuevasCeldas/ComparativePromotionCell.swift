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
        HStack(spacing: 12) {
            VStack(spacing: 4) {
                CachedAsyncImage(url: URL(string: promotion1.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                
                Text(promotion1.title)
                    .font(.caption2)
                    .lineLimit(2)
            }
            
            Divider()
            
            VStack(spacing: 4) {
                CachedAsyncImage(url: URL(string: promotion2.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                
                Text(promotion2.title)
                    .font(.caption2)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
