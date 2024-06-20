import SwiftUI

struct MainTabView: View {
    @State private var user = User(id: "2", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
            
            DailyPromotionsView()
                .tabItem {
                    Label("Días", systemImage: "calendar")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "heart")
                }
            
            ProfileView(user: user)
                .tabItem {
                    Label("Perfil", systemImage: user.isMerchant ? "briefcase" : "person")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
