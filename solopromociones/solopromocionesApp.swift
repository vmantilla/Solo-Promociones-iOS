//
//  solopromocionesApp.swift
//  solopromociones
//
//  Created by RAVIT Admin on 11/06/24.
//

import SwiftUI

@main
struct solopromocionesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
