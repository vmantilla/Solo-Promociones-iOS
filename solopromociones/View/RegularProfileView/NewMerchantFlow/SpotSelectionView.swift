//
//  SpotSelectionView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct SpotSelectionView: View {
    @Binding var selectedSpots: Int
    
    let spotOptions = [1, 3, 10, 20]
    
    func calculatePrice(for spots: Int) -> Int {
        switch spots {
        case 1:
            return 100
        case 3:
            return 270
        case 10:
            return 800
        case 20:
            return 1400
        default:
            return spots * 100
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Selecciona el número de spots publicitarios:")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(spotOptions, id: \.self) { spots in
                    Button(action: {
                        selectedSpots = spots
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(spots) spot\(spots > 1 ? "s" : "")")
                                Text("$\(calculatePrice(for: spots))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if selectedSpots == spots {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedSpots == spots ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 10) {
                    Text("¿Necesitas más de 20 spots?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("Contáctanos por WhatsApp para opciones personalizadas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: openWhatsApp) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Contactar por WhatsApp")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    func openWhatsApp() {
        if let whatsappURL = URL(string: "https://wa.me/573012107478") {
            UIApplication.shared.open(whatsappURL)
        }
    }
}
