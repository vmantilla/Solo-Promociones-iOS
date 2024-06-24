//
//  EditProfileView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var name: String
    @State private var newProfileImage: UIImage?
    @State private var newBackgroundImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.user.name)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                }
                
                Section(header: Text("Imagen de Perfil")) {
                    Button("Cambiar imagen de perfil") {
                        // Implementar selección de imagen
                    }
                }
                
                Section(header: Text("Imagen de Fondo")) {
                    Button("Cambiar imagen de fondo") {
                        // Implementar selección de imagen
                    }
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarItems(trailing: Button("Guardar") {
                viewModel.updateProfile(name: name, profileImage: newProfileImage, backgroundImage: newBackgroundImage)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)))
    }
}
