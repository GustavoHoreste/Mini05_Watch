//
//  TabViewWorkout.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI
import WatchKit

struct TabViewWorkout: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tabs = .exercise

    var body: some View {
        TabView(selection: $selection){
            StatusWorkoutView()
                .tag(Tabs.status)
            
            ExerciseProgressView()
                .tag(Tabs.exercise)
            
            NowPlayingView()
                .tag(Tabs.nowPlaying)
            
        }
        .background(.bg)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .tabViewStyle(.page)
        .onAppear{
            Task{
                await healthManager.startWorkout()
            }
            exerciseViewModel.selectExercise.append(.summary)
            let _ = print("O valor tem que ser 4 da quantidade de exercicios: ", exerciseViewModel.selectExercise.count, " e esses sao os valores ", exerciseViewModel.selectExercise)
        }
        .onChange(of: exerciseViewModel.isBackToView){ oldValue, newValue in
            displayMetricsView()
        }
        .navigationBarBackButtonHidden()
        
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .exercise
        }
    }
}

#Preview {
    TabViewWorkout()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}

