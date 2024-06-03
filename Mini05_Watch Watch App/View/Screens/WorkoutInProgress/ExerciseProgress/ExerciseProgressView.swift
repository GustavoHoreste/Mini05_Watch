//
//  ExerciseProgressView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ExerciseProgressView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    @State private var callSummaryView: Bool = false

    var body: some View {
        NavigationStack{
            Group{
                switch exerciseViewModel.selectExercise.first ?? .running12min{
                case .running12min:
                    MakeExerciseProgressView{
                        InformationViewComponemt(nameExercise: "Corrida",
                                                 value: healthManager.runningSpeed)
                    }
                case .pushUps, .abdominal:
                    MakeExerciseProgressView {
                        InformationViewComponemt(nameExercise: "Abdominal",
                                                 value: healthManager.runningSpeed)
                    }
                default:
                    EmptyView()
                    let _ = print("view vazia")
                }
            }
            .onAppear{
                if exerciseViewModel.selectExercise.first == .summary{
                    self.callSummaryView = true
                }
                exerciseViewModel.injectionStartDate(healthManager.builder?.startDate ?? Date())
            }
            .navigationDestination(isPresented: $callSummaryView) {
//                self.healthManager.endSession()
                withAnimation {
                    SummaryView()
                }
            }
        }
    }
}




struct MakeExerciseProgressView<T: View>: View {
    let content: T
    
    init(@ViewBuilder _ content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        TabView {
            TimerWorkoutView()
            self.content
        }.tabViewStyle(.carousel)
    }
}



#Preview {
    ExerciseProgressView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}

