//
//  BoldTitlePromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 18/06/24.
//

import SwiftUI
import CachedAsyncImage

struct BoldTitlePromotionCell: View {
    let promotion: Promotion

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(promotion.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            CachedAsyncImage(url: URL(string: promotion.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            Text(promotion.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}
