//
//  ProfileContainerView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import SwiftUI

struct ProfileContainerView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingAuthFlow = false
    @State private var showingSettings = false
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                RegularProfileView(viewModel: viewModel)
            } else {
                UnauthenticatedProfileView(viewModel: viewModel, showingAuthFlow: $showingAuthFlow, showingSettings: $showingSettings)
            }
        }
        .onAppear {
            viewModel.checkAuthenticationStatus()
        }
        .sheet(isPresented: $showingAuthFlow) {
            AuthenticationFlow(viewModel: viewModel)
        }
    }
}
