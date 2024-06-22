import SwiftUI

struct MainTabView: View {
    @State private var user = User(id: "2", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: true)
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView( viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(0)
            
            SearchView(viewModel: viewModel)
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            DailyPromotionsView()
                .tabItem {
                    Label("Días", systemImage: "calendar")
                }
                .tag(2)
            
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "heart")
                }
                .tag(3)
            
            ProfileView(user: user)
                .tabItem {
                    Label("Perfil", systemImage: user.isMerchant ? "briefcase" : "person")
                }
                .tag(4)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
