//
//  VerificationCodeView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct VerificationCodeView: View {
    @Binding var verificationCode: String
    @ObservedObject var viewModel: ProfileViewModel
    var presentationMode: Binding<PresentationMode>
    @State private var isLoading = false
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Ingresa el código de verificación")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Te hemos enviado un código de 6 dígitos por SMS")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            TextField("Código de 6 dígitos", text: $verificationCode)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                isLoading = true
                viewModel.authenticateUser(phoneNumber: "", verificationCode: verificationCode) { success in
                    isLoading = false
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showError = true
                    }
                }
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verificar")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(verificationCode.count != 6 || isLoading)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text("Código de verificación incorrecto. Por favor, intenta de nuevo."), dismissButton: .default(Text("OK")))
        }
    }
}
