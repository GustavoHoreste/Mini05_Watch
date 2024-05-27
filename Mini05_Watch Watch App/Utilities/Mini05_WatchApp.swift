//
//  Mini05_WatchApp.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 23/05/24.
//

import SwiftUI
import SwiftData

@main
struct Mini05_Watch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RunData.self])
    }
}
