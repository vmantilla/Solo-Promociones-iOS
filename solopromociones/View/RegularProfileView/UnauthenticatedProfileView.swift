import SwiftUI

struct UnauthenticatedProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingAuthFlow: Bool
    @Binding var showingSettings: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.blue.opacity(0.8))
                    .padding(.top, 16)

                VStack(spacing: 4) {
                    Text("Bienvenido a")
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    Text("¡Solo Promociones!")
                        .font(.title3)
                        .fontWeight(.semibold)
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
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Con una cuenta podrás:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.bottom, 4)

                    FeatureRow(icon: "heart", text: "Guardar tus comercios favoritos")
                    FeatureRow(icon: "bell", text: "Recibir notificaciones de promociones")
                    FeatureRow(icon: "star", text: "Calificar y comentar promociones")
                    FeatureRow(icon: "megaphone", text: "Publicar tus propias promociones")
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer(minLength: 40)
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
                        .font(.body)
                        .foregroundColor(.secondary)
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
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.blue.opacity(0.8))
                .frame(width: 24)
            Text(text)
                .font(.footnote)
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
