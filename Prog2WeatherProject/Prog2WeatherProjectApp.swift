//
//  Prog2WeatherProjectApp.swift
//  Prog2WeatherProject
//
//  Created by Attila Szél on 2021. 09. 28..
//

import SwiftUI

@main
struct Prog2WeatherProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
