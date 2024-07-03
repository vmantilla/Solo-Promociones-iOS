//
//  PromotionDetailView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI
import CachedAsyncImage

struct PromotionDetailView: View {
    let promotion: Promotion
    let storeName = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Imagen de la promoción
                CachedAsyncImage(url: URL(string: promotion.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 250)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(10)
                .shadow(radius: 5)

                // Título de la promoción
                Text(promotion.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Nombre de la tienda
                HStack {
                    Text("Tienda:")
                        .font(.headline)
                    Text(storeName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Descripción de la promoción
                Text(promotion.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                // Precios
                HStack {
                    Text("Precio original:")
                        .font(.headline)
                    Text("\(10.99, specifier: "%.2f")€")
                        .strikethrough()
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Precio Eco:")
                        .font(.headline)
                    Text("\(5.50, specifier: "%.2f")€")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                // Fecha de caducidad
                HStack {
                    Text("Caduca el:")
                        .font(.headline)
                    Text(Date().addingTimeInterval(5400), style: .date)
                        .foregroundColor(.red)
                }

                // Categoría
                HStack {
                    Text("Categoría:")
                        .font(.headline)
                    Text(promotion.category ?? "")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalles de la Promoción")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PromotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let promotion = Promotion(id: "1", title: "Oferta Especial", description: "Descripción de la oferta especial", validUntil: "30/07/2024", imageURL: "https://example.com/image.jpg", conditions: "Aplican restricciones")
        PromotionDetailView(promotion: promotion)
    }
}
