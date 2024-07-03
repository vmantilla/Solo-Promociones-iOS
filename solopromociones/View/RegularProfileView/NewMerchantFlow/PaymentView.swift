//
//  PaymentView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct PaymentView: View {
    let selectedSpots: Int
    let totalAmount: Int
    let onPaymentComplete: () -> Void
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isProcessingPayment = false
    @State private var showingSuccessMessage = false
    @State private var agreedToTerms = false
    @State private var showingTerms = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Resumen de compra")
                    .font(.headline)
                
                Text("Spots seleccionados: \(selectedSpots)")
                Text("Total a pagar: $\(totalAmount)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Detalles de la Tarjeta")
                    .font(.headline)
                
                TextField("Número de Tarjeta", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                HStack {
                    TextField("MM/YY", text: $expirationDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                TextField("Nombre del Titular", text: $cardholderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Acepto los términos y condiciones", isOn: $agreedToTerms)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    Button("Ver términos y condiciones") {
                        showingTerms = true
                    }
                    .foregroundColor(.blue)
                }
                
                Button(action: processPayment) {
                    Text("Pagar $\(totalAmount)")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(agreedToTerms ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!agreedToTerms)
            }
            .padding()
        }
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("¡Felicidades!"),
                message: Text("Ya eres un merchant. Ahora puedes publicar promociones."),
                dismissButton: .default(Text("OK")) {
                    onPaymentComplete()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingTerms) {
            TermsAndConditionsView(agreedToTerms: $agreedToTerms)
        }
        .overlay(
            ZStack {
                if isProcessingPayment {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Procesando pago...")
                            .font(.headline)
                            .padding(.top)
                    }
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        )
    }
    
    func processPayment() {
        isProcessingPayment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessingPayment = false
            showingSuccessMessage = true
        }
    }
}
