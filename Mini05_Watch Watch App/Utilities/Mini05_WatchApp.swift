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
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RunData.self, PushUpData.self, AbdominalData.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .environmentObject(exerciseViewModel)

            
        }
        .modelContainer(sharedModelContainer)
    }
}
