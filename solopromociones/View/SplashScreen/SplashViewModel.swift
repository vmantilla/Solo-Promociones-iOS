//
//  SplashViewModel.swift
//  solopromociones
//
//  Created by RAVIT Admin on 4/07/24.
//

import SwiftUI
import Foundation

class SplashViewModel: ObservableObject {
    @Published var isActive = true
    
    func dismissSplash() {
        withAnimation {
            self.isActive = false
        }
    }
}
