//
//  StatusWorkoutView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct StatusWorkoutView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                Text(exerciseViewModel.returnNameExercise())
                    .myCustonFont(fontName: .sairaMedium, size: 21.5, valueScaleFactor: 0.8)
                
                HStack{
                    ButtonStatusComponent(symbols: [.endSimbolo],
                                          nameButton: ["Finalizar", "Finalizar"],
                                          action:
                                            {
                                                healthManager.endSession()
                                                exerciseViewModel.toggleValueEnd()
                                            })
                    
                    ButtonStatusComponent(symbols: [.pauseSimbolo, .despauseSimbolo],
                                          nameButton: ["Pausar", "Retomar"],
                                          action:  {
                                                healthManager.togglePauseOrStart()
                                                exerciseViewModel.backToView()
                                            })
                }
                
                HStack{
                    ButtonStatusComponent(symbols: [.backSImbolo],
                                          nameButton: ["Anterior", "Anterior"],
                                          action:  {
                                                
                                          }).disabled(true)
                                            .hidden()
                    
                    
                    ButtonStatusComponent(symbols: [.endNext],
                                          nameButton: ["Próximo", "Próximo"],
                                          action:  {
                                                healthManager.pauseSession()
                                                if !(exerciseViewModel.selectExercise[1] == .summary){
                                                    exerciseViewModel.callSumaryView = true
                                                }else{
                                                    healthManager.endSession()
                                                    exerciseViewModel.toggleValueEnd()
                                                }
                                                saveData()
                                          })
                }
            }
            .onAppear{
                
            }
            .onDisappear{
                exerciseViewModel.isBackToView = false
            }
        }
    }
    
    private func saveData() {
        print("SELECT EXERCISE FIRST: \(exerciseViewModel.selectExercise.first!)")
        switch exerciseViewModel.selectExercise.first! {
        case .running12min:
            let runData = RunData(date: Date(), totalEnergy: healthManager.calories, avgHeartRate: healthManager.heartRate, avgSpeed: healthManager.runningSpeed, totalDistance: healthManager.distanceWalkingRunning / 1000)
            
            modelContext.insert(runData)
        case .pushUps:
            let pushUpData = PushUpData(date: Date(), totalEnergy: healthManager.calories, avgHeartRate: healthManager.heartRate, repetitions: exerciseViewModel.abdomenTrincado)
            
            modelContext.insert(pushUpData)
        default:
            let abdominalData = AbdominalData(date: Date(), totalEnergy: healthManager.calories, avgHeartRate: healthManager.heartRate, repetitions: exerciseViewModel.abdomenTrincado)
            
            modelContext.insert(abdominalData)
        }
    }
}



#Preview {
    StatusWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}


