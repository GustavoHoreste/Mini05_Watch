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
                    ButtonStatusComponent(symbol: [.endSimbolo],
                                          nameButton: ["Finalizar"],
                                          action:
                                            {
                                                healthManager.endSession()
                                                exerciseViewModel.toggleValueEnd()
                                            })
                    
                    ButtonStatusComponent(symbol: [.pauseSimbolo, .despauseSimbolo],
                                          nameButton: ["Pausar", "Retomar"],
                                          action:  {
                                                healthManager.togglePauseOrStart()
                                                exerciseViewModel.backToView()
                                            })
                }
                
                HStack{
                    ButtonStatusComponent(symbol: [.backSImbolo],
                                          nameButton: ["Anterior"],
                                          action:  {
                                                
                                          }).disabled(true)
                    
                    ButtonStatusComponent(symbol: [.endNext],
                                          nameButton: ["Próximo"],
                                          action:  {
                                                healthManager.pauseSession()
//                                                exerciseViewModel.backToView()
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
            .navigationDestination(isPresented: $exerciseViewModel.endWorkout) {
                if exerciseViewModel.endWorkout{
                    SummaryGeralView()// Quando Termina chama a view final
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
            .sheet(isPresented: $exerciseViewModel.callSumaryView) {
                if exerciseViewModel.callSumaryView{
                    withAnimation {
                        SummaryView()
                            .toolbar(.hidden, for: .navigationBar)
                    }
                }
            }
            .onDisappear{
                exerciseViewModel.isBackToView = false
                exerciseViewModel.callSumaryView = false
            }
        }
    }
    
    private func saveData() {
        print("SELECT EXERCISE FIRST: \(exerciseViewModel.selectExercise.first!)")
        switch exerciseViewModel.selectExercise.first! {
        case .running12min:
            let runData = RunData(date: Date(), totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, avgSpeed: healthManager.runningSpeed)
            
            modelContext.insert(runData)
        case .pushUps:
            let pushUpData = PushUpData(date: Date(), totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, repetitions: healthManager.repetitions)
            
            modelContext.insert(pushUpData)
        default:
            let abdominalData = AbdominalData(date: Date(), totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, repetitions: healthManager.repetitions)
            
            modelContext.insert(abdominalData)
        }
    }
}



#Preview {
    StatusWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}


