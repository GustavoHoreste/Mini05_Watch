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
    @StateObject private var healthManager: HealthKitManager = HealthKitManager()
    @StateObject private var exerciseViewModel: ExerciseProgressViewModel = ExerciseProgressViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .environmentObject(exerciseViewModel)

        }
        .modelContainer(for: [RunData.self])
    }
}
