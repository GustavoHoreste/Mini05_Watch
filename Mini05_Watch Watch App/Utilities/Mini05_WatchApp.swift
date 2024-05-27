//
//  Mini05_WatchApp.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 23/05/24.
//

import SwiftUI

@main
struct Mini05_Watch_Watch_AppApp: App {
    @StateObject private var healthManager: HealthKitManager = HealthKitManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)

        }
    }
}
