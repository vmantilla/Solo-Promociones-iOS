//
//  ToGoodToGOCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct ToGoodToGOCell: View {
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
                    Text("Nombre de la Tienda") // Asumiendo que no está en el modelo Promotion
                        .font(.caption)
                        .foregroundColor(.secondary)
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
                    Text("Precio original: 20.00€") // Asumiendo un precio original
                        .strikethrough()
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text("Precio Promoción: 15.00€") // Asumiendo un precio con descuento
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Válido hasta:")
                        .font(.caption)
                    Text(promotion.validUntil)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }

            HStack {
                Image(systemName: "location")
                Text("2.5 km") // Asumiendo una distancia
                Spacer()
                Text("Categoría") // Asumiendo una categoría
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

