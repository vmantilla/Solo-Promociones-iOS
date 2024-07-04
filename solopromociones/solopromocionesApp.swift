import SwiftUI

import SwiftUI

@main
struct solopromocionesApp: App {
    @StateObject private var splashViewModel = SplashViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                if splashViewModel.isActive {
                    SplashScreen(name: "splash_animation")
                        .environmentObject(splashViewModel)
                        .transition(.opacity)
                }
            }
        }
    }
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
