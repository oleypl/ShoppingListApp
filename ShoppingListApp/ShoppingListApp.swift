//
//  ShoppingListAppApp.swift
//  ShoppingListApp
//
//  Created by Michal on 21/10/2022.
//

import SwiftUI

@main
struct ShoppingListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
