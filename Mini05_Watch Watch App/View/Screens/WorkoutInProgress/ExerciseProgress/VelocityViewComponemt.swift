//
//  VelocityViewComponemt.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI

struct VelocityViewComponemt: View {
    @EnvironmentObject private var healthManager: HealthKitManager

    var body: some View {
        VStack{
            Text("\(healthManager.runningSpeed , specifier: "%.0f")Km/h")
                .font(.system(size: 60))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "m/s",
                                systemImage: "bolt.fill",
                                value: healthManager.runningSpeed))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "km",
                                systemImage: "map.fill",
                                value: healthManager.distanceWalkingRunning))
        }
    }
}

#Preview {
    VelocityViewComponemt()
        .environmentObject(HealthKitManager())
}
