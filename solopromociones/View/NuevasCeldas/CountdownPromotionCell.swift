//
//  CountdownPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI
import CachedAsyncImage

struct CountdownPromotionCell: View {
    let promotion: Promotion
    @State private var timeRemaining: TimeInterval = 3600 // Example: 1 hour
    
    var body: some View {
        VStack {
            StandardPromotionCell(promotion: promotion)
            
            HStack {
                Text("Termina en:")
                Text("\(timeString(from: timeRemaining))")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

struct CountdownPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        CountdownPromotionCell(promotion: Promotion(id: "1", title: "2x1 en Cocteles", description: "Disfruta de 2 cocteles por el precio de 1 en nuestro bar.", validUntil: "30/06/2024", imageURL: "https://dummyimage.com/600x400/000/fff", conditions: "Solo en barra."))
    }
}
