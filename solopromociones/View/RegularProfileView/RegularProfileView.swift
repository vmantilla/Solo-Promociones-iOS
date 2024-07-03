import SwiftUI

struct RegularProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
            }
            .frame(height: 0)
            
            VStack(spacing: 20) {
                ProfileHeaderView(viewModel: viewModel, showingEditProfile: $showingEditProfile)
                StatsView()
                FavoriteMerchantsView()
                BecomeAMerchantBanner(viewModel: viewModel)
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
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
        .navigationTitle(scrollOffset < -50 ? viewModel.user?.name ?? "" : "")
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showingEditProfile: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let profileImage = viewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.user?.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(viewModel.user?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Usuario")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Button(action: {
                showingEditProfile = true
            }) {
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct StatsView: View {
    var body: some View {
        HStack {
            Spacer()
            StatView(title: "Favoritos", value: "15")
            Spacer()
            StatView(title: "Reseñas", value: "8")
            Spacer()
            StatView(title: "Puntos", value: "350")
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct FavoriteMerchantsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Comercios Favoritos")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(1...5, id: \.self) { _ in
                        FavoriteMerchantCell()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct FavoriteMerchantCell: View {
    var body: some View {
        VStack {
            Image(systemName: "storefront")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            Text("Tienda Ejemplo")
                .font(.caption)
        }
        .frame(width: 80, height: 80)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct BecomeAMerchantBanner: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingMerchantFlow = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("¿Tienes un negocio?")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Conviértete en comerciante y comienza a publicar tus promociones hoy mismo.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                showingMerchantFlow = true
            }) {
                Text("Convertirme en comerciante")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .fullScreenCover(isPresented: $showingMerchantFlow) {
            MerchantFlowView(viewModel: viewModel)
        }
    }
}

struct RegularProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegularProfileView(viewModel: ProfileViewModel())
        }
    }
}
