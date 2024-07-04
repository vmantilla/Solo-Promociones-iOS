import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingAddPromotion = false
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel())
    }
    
    var body: some View {
            NavigationView {
                if viewModel.isMerchant {
                    MerchantProfileView(viewModel: viewModel)
                } else {
                    ProfileContainerView(viewModel: viewModel)
                }
            }
        }
}
