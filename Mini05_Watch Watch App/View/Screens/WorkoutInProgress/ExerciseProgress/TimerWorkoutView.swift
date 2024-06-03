//
//  TimerWorkoutView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 29/05/24.
//

import SwiftUI

struct TimerWorkoutView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @State private var provisoryValue: Double = 12.4

    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
            VStack(alignment: .center){
                Text("Cronômetro")
                    .font(.callout)
                
                ///Tempo de avalição atual
                ElapsedTimeView(elapsedTime: upadateTimerValue(at: value.date), showSubseconds: false)
                    .font(.system(size: 30))
                
                ///Tempo geral
                ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: value.cadence == .live)
                
                Divider()
                
                HStack{
                   RecordTimeComponent(value: .constant(42.4), name: "Maior Tempo")
                   RecordTimeComponent(value: .constant(12.4), name: "Menor Tempo")
                }
            }
        }
    }
}

extension TimerWorkoutView{
    private func upadateTimerValue(at value: Date) -> Double{
        if exerciseViewModel.isDecrementingTimer && exerciseViewModel.selectExercise.first == .running12min{
            return exerciseViewModel.remainingTime(at: value)
        }
        return healthManager.builder?.elapsedTime(at: value) ?? 0
    }
}



#Preview {
    TimerWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}
