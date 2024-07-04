import SwiftUI
import CachedAsyncImage

struct TimelinePromotionCell: View {
    let promotions: [Promotion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Próximos Eventos")
                .font(.subheadline)
                .fontWeight(.medium)
            
            ForEach(promotions) { promotion in
                HStack(alignment: .top, spacing: 12) {
                    VStack {
                        Circle()
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 16, height: 16)
                        Rectangle()
                            .fill(Color.blue.opacity(0.8))
                            .frame(width: 1)
                    }
                    .frame(height: 100)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(promotion.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        HStack {
                            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(6)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(promotion.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                                
                                Text("Válido hasta: \(promotion.validUntil)")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                                
                                Text(promotion.conditions)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
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

struct TimelinePromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        TimelinePromotionCell(promotions: [
            Promotion(id: "1", title: "Noche de Jazz", description: "Disfruta de una noche de jazz con los mejores músicos locales.", validUntil: "30/06/2024", imageURL: "https://example.com/jazz.jpg", conditions: "Entrada libre hasta completar aforo."),
            Promotion(id: "2", title: "Festival de Comida", description: "Prueba platos de todo el mundo en nuestro festival gastronómico.", validUntil: "15/07/2024", imageURL: "https://example.com/food.jpg", conditions: "Compra de tickets en la entrada."),
            Promotion(id: "3", title: "Exposición de Arte", description: "Visita nuestra galería y admira obras de artistas emergentes.", validUntil: "31/07/2024", imageURL: "https://example.com/art.jpg", conditions: "Visitas guiadas disponibles.")
        ])
    }
}
