//
//  PhoneNumberView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct PhoneNumberView: View {
    @Binding var phoneNumber: String
    @Binding var showingVerificationView: Bool
    
    var body: some View {
        VStack {
            TextField("Número de teléfono", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding()
            
            Button("Enviar código") {
                // Aquí se enviaría el código de verificación
                showingVerificationView = true
            }
            .padding()
        }
    }
}
