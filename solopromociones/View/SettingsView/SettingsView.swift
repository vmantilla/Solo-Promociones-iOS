//
//  SettingsView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 2/07/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var language = "Español"
    @State private var currency = "EUR"
    @State private var showDeleteAccountAlert = false
    
    let languages = ["Español", "English", "Français", "Deutsch"]
    let currencies = ["EUR", "USD", "GBP"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preferencias")) {
                    Toggle("Notificaciones", isOn: $notificationsEnabled)
                    Toggle("Modo Oscuro", isOn: $darkModeEnabled)
                    
                    Picker("Idioma", selection: $language) {
                        ForEach(languages, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Moneda", selection: $currency) {
                        ForEach(currencies, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Cuenta")) {
                    NavigationLink(destination: Text("Pantalla de cambio de contraseña")) {
                        Text("Cambiar Contraseña")
                    }
                    NavigationLink(destination: Text("Pantalla de privacidad")) {
                        Text("Privacidad")
                    }
                    NavigationLink(destination: Text("Pantalla de términos y condiciones")) {
                        Text("Términos y Condiciones")
                    }
                }
                
                Section(header: Text("Soporte")) {
                    NavigationLink(destination: Text("Pantalla de ayuda")) {
                        Text("Ayuda")
                    }
                    NavigationLink(destination: Text("Pantalla de contacto")) {
                        Text("Contactar Soporte")
                    }
                }
                
                Section {
                    Button(action: {
                        // Acción para cerrar sesión
                    }) {
                        Text("Cerrar Sesión")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showDeleteAccountAlert = true
                    }) {
                        Text("Eliminar Cuenta")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showDeleteAccountAlert) {
                Alert(
                    title: Text("¿Estás seguro?"),
                    message: Text("Eliminar tu cuenta es una acción permanente y no se puede deshacer."),
                    primaryButton: .destructive(Text("Eliminar")) {
                        // Acción para eliminar la cuenta
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
