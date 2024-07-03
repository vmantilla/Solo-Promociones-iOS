import SwiftUI

struct MainTabView: View {
    @State private var user = User(id: "2", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: false)
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag(0)
            
            DailyPromotionsView()
                .tabItem {
                    Label("Días", systemImage: "calendar")
                }
                .tag(1)
            
            TooGoodToGoView()
                .tabItem {
                    Label {
                        Text("EcoOfertas")
                    } icon: {
                        Image(systemName: "leaf.arrow.circlepath")
                            .foregroundColor(.green)
                    }
                }
                .tag(2)
            
            ProfileView(user: user)
                .tabItem {
                    Label("Perfil", systemImage: user.isMerchant ? "briefcase" : "person")
                }
                .tag(3)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
