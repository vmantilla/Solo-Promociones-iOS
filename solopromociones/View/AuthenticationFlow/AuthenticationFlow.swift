//
//  AuthenticationFlow.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct AuthenticationFlow: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var showingVerificationView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Group {
                if !showingVerificationView {
                    PhoneNumberView(phoneNumber: $phoneNumber, showingVerificationView: $showingVerificationView)
                } else {
                    VerificationCodeView(verificationCode: $verificationCode, viewModel: viewModel, presentationMode: presentationMode)
                }
            }
            .navigationBarTitle("Autenticación", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
