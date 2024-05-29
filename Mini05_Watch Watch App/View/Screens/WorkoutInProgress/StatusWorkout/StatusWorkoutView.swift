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
            VStack {
                HStack {
                    ButtonStatusComponent(symbol: ["pause.fill", "play.fill"],
                                          nameButton: ["Pause", "Play"],
                                          action:  {
                                                healthManager.togglePauseOrStart()
                                                exerciseViewModel.backToView()
                                            },
                                          isPauseOrPlay: true)
                    
                    Spacer()
                    ButtonStatusComponent(symbol: ["xmark"],
                                          nameButton: ["Sair"],
                                          action:  
                                            {
                                                healthManager.endSession()
                                                exerciseViewModel.toggleValueEnd()
                                                exerciseViewModel.backToView()
                                            },
                                          isPauseOrPlay: false)
                }
                
                HStack{
                    Spacer()
                    ButtonStatusComponent(symbol: ["arrowshape.turn.up.right.fill"],
                                          nameButton: ["Próximo"],
                                          action:  {
                                                print("Próximo")
                                                exerciseViewModel.nextExercise()
                                                exerciseViewModel.backToView()
                                            },
                                          isPauseOrPlay: false)
                }.padding(.top)
                
            }
            .padding(.top)
            .navigationTitle(exerciseViewModel.selectExercise.first?.rawValue ?? "Status")
            .navigationDestination(isPresented: $exerciseViewModel.endWorkout) {
                SummaryView()
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
}


