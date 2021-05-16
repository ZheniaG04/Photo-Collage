//
//  Photo_CollageApp.swift
//  Photo Collage
//
//  Created by Женя on 16.05.2021.
//

import SwiftUI

@main
struct Photo_CollageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
