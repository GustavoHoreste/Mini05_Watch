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
    @State private var canCallSummaryView: Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            Text(self.exerciseViewModel.returnNameExercise())
                .myCustonFont(fontName: .sairaRegular, size: 23.5, valueScaleFactor: 0.8)
            
            Text("Cronômetro")
                .myCustonFont(fontName: .sairaRegular, size: 18, valueScaleFactor: 0.8)
            
            ///Tempo de avalição atual
            TimelineView(MetricsTimelineSchedule(from: exerciseViewModel.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                ElapsedTimeView(elapsedTime: upadateTimerValue(at: value.date), showSubseconds: false)
                    .foregroundStyle(.myOrange)
                    
            }
            
            ///Tempo geral
            TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                
                ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: value.cadence == .live)
                    .foregroundStyle(.myOrange.opacity(0.7))
            }
            .onChange(of: exerciseViewModel.selectExercise) { oldValue, newValue in
                if newValue.count != oldValue.count{
                    self.canCallSummaryView = true
                    print("nova date")
                }
            }
//            Group{
//                Divider()
//                    .overlay(Color(.spacer))
//                    .padding(.horizontal, 20)
//                RecordTimeComponent(value: .constant(42.4), name: "Maior Tempo")
//            }
//            .padding(.top)
//            .onChange(of: exerciseViewModel.selectExercise) { oldValue, newValue in
//                if newValue.count != oldValue.count{
//                    self.canCallSummaryView = true
//                    print("nova date")
//                }
//            }
        }
    }
}

extension TimerWorkoutView{
    private func upadateTimerValue(at value: Date) -> Double{
        if exerciseViewModel.startDate == nil{
            exerciseViewModel.startDate = Date()
        }
        
        if !healthManager.forcePause{
            self.healthManager.calcTimeExercise(value, exerciseViewModel.startDate!, exerciseViewModel.selectExercise.first ?? .running12min)
        }
        if exerciseViewModel.isDecrementingTimer && exerciseViewModel.selectExercise.first == .running12min && !exerciseViewModel.toSummaryViewAfterTime{
            let time = exerciseViewModel.remainingTime(at: value)
            
            if time == 0 && self.canCallSummaryView {
                self.exerciseViewModel.callSumarryView()
                self.healthManager.pauseSession()
                DispatchQueue.main.async {
                    self.canCallSummaryView = false
                }
            }
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
