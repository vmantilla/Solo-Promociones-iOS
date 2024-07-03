//
//  BusinessInfoView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct BusinessInfoView: View {
    @Binding var businessName: String
    @Binding var businessAddress: String
    @Binding var businessPhone: String
    
    var body: some View {
        Form {
            Section(header: Text("Información del Negocio")) {
                TextField("Nombre del Negocio", text: $businessName)
                TextField("Dirección", text: $businessAddress)
                TextField("Teléfono", text: $businessPhone)
                    .keyboardType(.phonePad)
            }
        }
    }
}
