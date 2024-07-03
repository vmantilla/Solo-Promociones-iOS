//
//  UnauthenticatedProfileView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct UnauthenticatedProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingAuthFlow: Bool
    @Binding var showingSettings: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Bienvenido a Solo Promociones")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                Text("Para acceder a todas las funcionalidades, por favor inicia sesión.")
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    showingAuthFlow = true
                }) {
                    Text("Iniciar Sesión")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Con una cuenta podrás:")
                        .font(.headline)

                    BulletPoint(text: "Guardar tus comercios favoritos")
                    BulletPoint(text: "Recibir notificaciones de promociones")
                    BulletPoint(text: "Calificar y comentar promociones")
                    BulletPoint(text: "Publicar tus propias promociones como comerciante")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()

                Spacer(minLength: 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct BulletPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top) {
            Text("•")
            Text(text)
        }
    }
}
