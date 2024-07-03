import SwiftUI

struct UnauthenticatedProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingAuthFlow: Bool
    @Binding var showingSettings: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top, 20)

                VStack(spacing: 5) {
                    Text("Bienvenido a")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("¡Solo Promociones!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                Text("Inicia sesión para disfrutar de todas las funcionalidades")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

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

                VStack(alignment: .leading, spacing: 20) {
                    Text("Con una cuenta podrás:")
                        .font(.headline)
                        .padding(.bottom, 5)

                    FeatureRow(icon: "heart.fill", text: "Guardar tus comercios favoritos")
                    FeatureRow(icon: "bell.fill", text: "Recibir notificaciones de promociones")
                    FeatureRow(icon: "star.fill", text: "Calificar y comentar promociones")
                    FeatureRow(icon: "megaphone.fill", text: "Publicar tus propias promociones")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct UnauthenticatedProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UnauthenticatedProfileView(viewModel: ProfileViewModel(), showingAuthFlow: .constant(false), showingSettings: .constant(false))
        }
    }
}
