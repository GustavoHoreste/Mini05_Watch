//
//  HeartAndCaloriesViewComponemt.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI

struct HeartAndCaloriesViewComponemt: View {
    @EnvironmentObject private var healthManager: HealthKitManager

    var body: some View {
        VStack(spacing: 0){
            Divider()
                .overlay(Color(.spacer))
                
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "bpm",
                                systemImage: "bolt.heart",
                                value: healthManager.heartRate))
            
            Divider()
                .overlay(Color(.spacer))
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "cal",
                                systemImage: "flame.fill",
                                value: healthManager.calories))
        }.padding(.horizontal)
    }
}

#Preview {
    HeartAndCaloriesViewComponemt()
        .environmentObject(HealthKitManager())
}
