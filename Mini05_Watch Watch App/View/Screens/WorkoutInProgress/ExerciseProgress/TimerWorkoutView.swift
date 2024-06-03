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
    @State private var reseatTime: Bool = false

    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
            VStack(alignment: .center){
                
                Text(self.returnNameExercise())
                    .font(.system(size: 20))
                
                Text("Cronômetro")
                    .font(.system(size: 14))
                
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
            }.onChange(of: exerciseViewModel.selectExercise) { oldValue, newValue in
                if newValue.count < oldValue.count{
                    self.reseatTime = true
                }
            }
        }
    }
}

extension TimerWorkoutView{
    private func upadateTimerValue(at value: Date) -> Double{
        if self.reseatTime{
            DispatchQueue.main.async {
                self.reseatTime = false
            }
            return value.timeIntervalSince(Date())
        }
        
        if exerciseViewModel.isDecrementingTimer && exerciseViewModel.selectExercise.first == .running12min{
            return exerciseViewModel.remainingTime(at: value)
        }
        return healthManager.builder?.elapsedTime(at: value) ?? 0
        
    }
    
    private func returnNameExercise() -> String{
        guard let name = exerciseViewModel.selectExercise.first else {
            return "nil"
        }
        return name.rawValue
    }
}



#Preview {
    TimerWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}
