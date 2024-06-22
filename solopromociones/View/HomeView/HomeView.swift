import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    headerSection
                    
                    searchSection
                    
                    filterSection
                    
                    featuredSection
                    
                    inspirationSection
                    
                    attractionsSection
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Buscar atracciones en")
                    .font(.headline)
                    .foregroundColor(.secondary)
                HStack {
                    Text("Ámsterdam")
                        .font(.largeTitle)
                        .bold()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Button(action: {}) {
                Text("Comprar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
    
    private var searchSection: some View {
        VStack {
            TextField("Buscar en Ámsterdam", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 10)
        }
    }
    
    private var filterSection: some View {
        HStack {
            filterButton(title: "Abierto hasta tarde")
            filterButton(title: "Al aire libre")
            filterButton(title: "Cerca de ti")
        }
        .padding(.vertical)
    }
    
    private func filterButton(title: String) -> some View {
        Button(action: {}) {
            Text(title)
                .font(.subheadline)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image("61D9BDE0-406D-490A-82C3-47416F58A898") // Replace with your actual image asset
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
            Text("¿No sabes por dónde empezar?")
                .font(.title2)
                .bold()
            Text("Descubre las atracciones más populares de Ámsterdam")
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
    
    private var inspirationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Déjate inspirar")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("¿Todavía no tienes un pase?")
                        .font(.headline)
                    Spacer()
                    Button(action: {}) {
                        Text("Comprar un pase")
                            .foregroundColor(.blue)
                    }
                }
                Text("No te pierdas todas las ventajas de nuestros pases, más información en GoCity.com")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.vertical)
    }
    
    private var attractionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Todas las atracciones")
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {}) {
                    Text("Ver todas (46)")
                        .foregroundColor(.blue)
                }
            }
            ForEach(0..<5) { _ in
                HStack {
                    Image("61D9BDE0-406D-490A-82C3-47416F58A898") // Replace with your actual image asset
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text("Experiencia Heineken")
                            .font(.headline)
                        Text("Reserva obligatoria")
                            .foregroundColor(.orange)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.vertical)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
