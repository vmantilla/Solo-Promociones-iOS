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
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "phone.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Ingresa tu número de teléfono")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Te enviaremos un código de verificación por SMS")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                Text("+57")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                TextField("Número de teléfono", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button(action: {
                isLoading = true
                // Simular envío de código
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                    showingVerificationView = true
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Enviar código")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(phoneNumber.count < 10 || isLoading)
            
            Spacer()
        }
        .padding()
    }
}
