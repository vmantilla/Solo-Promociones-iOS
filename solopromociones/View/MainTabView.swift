import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var userSession = UserSession.shared
    
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
            
            if let user = userSession.currentUser {
                ProfileView(user: user)
                    .tabItem {
                        Label("Perfil", systemImage: user.isMerchant ? "briefcase" : "person")
                    }
                    .tag(3)
            }
        }
        .onAppear {
            userSession.loadFromUserDefaults()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
