import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingAddPromotion = false
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
            NavigationView {
                if viewModel.isMerchant {
                    MerchantProfileView(viewModel: viewModel)
                } else {
                    RegularProfileView(viewModel: viewModel)
                }
            }
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: false))
    }
}
