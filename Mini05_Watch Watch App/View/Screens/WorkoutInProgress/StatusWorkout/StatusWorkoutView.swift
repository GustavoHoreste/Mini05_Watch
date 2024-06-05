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

    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                Text(exerciseViewModel.returnNameExercise())
                    .myCustonFont(fontName: .sairaMedium, size: 21.5, valueScaleFactor: 0.8)
                
                HStack{
                    ButtonStatusComponent(symbol: [.pauseSimbolo, .despauseSimbolo],
                                          nameButton: ["Pausar", "Recomeçar"],
                                          action:  {
                                                healthManager.togglePauseOrStart()
                                                exerciseViewModel.backToView()
                                            })
                    
                    ButtonStatusComponent(symbol: [.endSimbolo],
                                          nameButton: ["Finalizar"],
                                          action:
                                            {
                                                healthManager.endSession()
                                                exerciseViewModel.toggleValueEnd()
//                                                exerciseViewModel.backToView()
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
                                                //healthManager.togglePauseOrStart()
                                                exerciseViewModel.nextExercise()
                                                exerciseViewModel.callSumaryView = true
//                                                exerciseViewModel.backToView()
                                          })
                    
                }
            }
            .navigationDestination(isPresented: $exerciseViewModel.endWorkout) {
                if exerciseViewModel.endWorkout{
                    SummaryView()// Quando Termina chama a view final
                }
            }
            .navigationDestination(isPresented: $exerciseViewModel.callSumaryView) {
                if exerciseViewModel.callSumaryView{
                    SummaryView()// Chama o sumario parcial
                }
            }
            .onDisappear{
                exerciseViewModel.isBackToView = false
            }
        }
    }
}



#Preview {
    StatusWorkoutView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}


