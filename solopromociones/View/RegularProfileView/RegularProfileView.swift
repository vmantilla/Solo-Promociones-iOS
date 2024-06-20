import SwiftUI

struct RegularProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Usuario: \(viewModel.user.name)")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                
                Text("Información del usuario")
                    .font(.title2)
                    .padding(.horizontal)
                
                List {
                    Text("Nombre: \(viewModel.user.name)")
                    Text("Email: \(viewModel.user.email)")
                    Toggle("Modo Merchant", isOn: $viewModel.isMerchant)
                        .onChange(of: viewModel.isMerchant) { _ in
                            viewModel.toggleMerchantStatus()
                        }
                }
            }
            .navigationTitle("Perfil Usuario")
            .navigationBarItems(trailing: Image(systemName: "person"))
        }
    }
}

struct RegularProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RegularProfileView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: false)))
    }
}
