//
//  SummaryView.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SummaryDataComponent(title: "Total Time",
                                     extensionName: "",
                                     value: 0)
                    .foregroundStyle(.yellow)
                SummaryDataComponent(title: "Total Distance",
                                     extensionName: "m",
                                     value: healthManager.distanceWalkingRunning)
                    .foregroundStyle(.green)
                SummaryDataComponent(title: "Total Energy",
                                     extensionName: "Cal",
                                     value: healthManager.activeEnergyBurned)
                        .foregroundStyle(.pink)
                SummaryDataComponent(title: "Avg. Heart Rate",
                                     extensionName: "bpm",
                                     value: healthManager.heartRate)
                    .foregroundStyle(.red)
                SummaryDataComponent(title: "Avg. Speed",
                                     extensionName: "M/s",
                                     value: healthManager.runningSpeed) //se pa nao ta pegando velocidade media
                    .foregroundStyle(.orange)
                
                NavigationLink {
                    HomeView()
                } label: {
                    Text("Done")
                }.onTapGesture{
                    healthManager.resetWorkoutData()
                }

            }
            .scenePadding()
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SummaryView()
}

