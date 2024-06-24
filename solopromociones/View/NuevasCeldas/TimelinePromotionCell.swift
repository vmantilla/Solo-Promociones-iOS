import SwiftUI
import CachedAsyncImage

struct TimelinePromotionCell: View {
    let promotions: [Promotion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Próximos Eventos")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(promotions) { promotion in
                HStack(alignment: .top, spacing: 15) {
                    VStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 2)
                    }
                    .frame(height: 120)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(promotion.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            CachedAsyncImage(url: URL(string: promotion.imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(promotion.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                                
                                Text("Válido hasta: \(promotion.validUntil)")
                                    .font(.caption)
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
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
