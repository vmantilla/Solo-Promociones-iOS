import SwiftUI
import Foundation

class SplashViewModel: ObservableObject {
    @Published var isActive = true
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var webURL: URL? = URL(string: "https://www.solopromociones.com")
    
    private let authService: AuthServiceProtocol
    private let userSession: UserSession
    
    private var animationFinished = false
    private var authenticationCompleted = false
    
    init(authService: AuthServiceProtocol = AuthService(), userSession: UserSession = .shared) {
        self.authService = authService
        self.userSession = userSession
    }
    
    func dismissSplashIfNeeded() {
        if animationFinished && authenticationCompleted && !showError {
            Task { @MainActor in
                withAnimation {
                    self.isActive = false
                }
            }
        }
    }
    
    func markAnimationFinished() {
        animationFinished = true
        dismissSplashIfNeeded()
    }
    
    func authenticateIfNeeded() {
        Task {
            if !userSession.isLoggedIn() {
                await authenticateAnonymously()
            } else {
                authenticationCompleted = true
                dismissSplashIfNeeded()
            }
        }
    }
    
    private func authenticateAnonymously() async {
        do {
            let authResponse = try await authService.authenticateAnonymously()
            let user = User(id: authResponse.user.id, name: "", email: authResponse.user.email, isMerchant: false, anonymous: authResponse.user.anonymous)
            await userSession.login(user: user, token: authResponse.token)
            authenticationCompleted = true
            dismissSplashIfNeeded()
        } catch {
            Task { @MainActor in
                self.showError = true
                self.errorMessage = "Ha ocurrido un error durante la autenticación. Estamos trabajando para solucionarlo."
            }
        }
    }
}
