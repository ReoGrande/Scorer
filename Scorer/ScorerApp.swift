//
//  ScorerApp.swift
//  Scorer
//
//  Created by user on 2/17/24.
//

import SwiftUI

@main
struct ScorerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
