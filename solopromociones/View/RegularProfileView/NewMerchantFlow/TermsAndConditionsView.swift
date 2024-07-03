//
//  TermsAndConditionsView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @Binding var agreedToTerms: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Términos y Condiciones")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("1. Uso del servicio")
                        .font(.headline)
                    Text("Al utilizar nuestro servicio, usted acepta cumplir con estos términos y condiciones...")
                    
                    Text("2. Responsabilidades del usuario")
                        .font(.headline)
                    Text("El usuario es responsable de mantener la confidencialidad de su cuenta...")
                    
                    Text("3. Política de privacidad")
                        .font(.headline)
                    Text("Nuestra política de privacidad describe cómo recopilamos y utilizamos la información...")
                    
                    // Añade más secciones según sea necesario
                    
                    Toggle("Acepto los términos y condiciones", isOn: $agreedToTerms)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.top)
                }
                .padding()
            }
            .navigationBarTitle("Términos y Condiciones", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
