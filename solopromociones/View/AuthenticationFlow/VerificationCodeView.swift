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
    
    var body: some View {
        VStack {
            TextField("Código de verificación", text: $verificationCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding()
            
            Button("Verificar") {
                viewModel.authenticateUser(phoneNumber: "", verificationCode: verificationCode) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
        }
    }
}
