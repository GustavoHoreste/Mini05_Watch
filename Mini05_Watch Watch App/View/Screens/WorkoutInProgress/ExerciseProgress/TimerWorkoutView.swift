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
    @State private var nextView: Bool = false
    
    var body: some View {
        VStack(alignment: .center){
            Text(self.exerciseViewModel.returnNameExercise())
                .font(.system(size: 20))
            
            Text("Cronômetro")
                .font(.system(size: 14))
            
            ///Tempo de avalição atual
            TimelineView(MetricsTimelineSchedule(from: exerciseViewModel.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                ElapsedTimeView(elapsedTime: upadateTimerValue(at: value.date), showSubseconds: false)
                    .font(.system(size: 30))
            }
            
            ///Tempo geral
            TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                
                ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: value.cadence == .live)
            }
            
            Divider()
            RecordTimeComponent(value: .constant(42.4), name: "Maior Tempo")
            .onChange(of: exerciseViewModel.selectExercise) { oldValue, newValue in
                if newValue.count != oldValue.count{
                    exerciseViewModel.startDate = Date()
                    print("nova date")
                }
            }
            .navigationDestination(isPresented: $exerciseViewModel.toSummaryViewAfterTime) {
                SummaryView()// sumario parcial
            }
        }
    }
}

extension TimerWorkoutView{
    private func upadateTimerValue(at value: Date) -> Double{
        if exerciseViewModel.startDate == nil{
            exerciseViewModel.startDate = Date()
        }
        if exerciseViewModel.isDecrementingTimer && exerciseViewModel.selectExercise.first == .running12min && !exerciseViewModel.toSummaryViewAfterTime{
            let time = exerciseViewModel.remainingTime(at: value)
            return time
        }
        return value.timeIntervalSince(exerciseViewModel.startDate!)
    }
}



#Preview {
    TimerWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}
