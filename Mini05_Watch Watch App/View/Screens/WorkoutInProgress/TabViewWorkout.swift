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
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .tabViewStyle(.page)
        .onAppear{
            exerciseViewModel.allselectExercise = exerciseViewModel.selectExercise
            Task{
                await healthManager.startWorkout()
            }
            
            exerciseViewModel.selectExercise.append(.summary)
            
        }
        .onChange(of: exerciseViewModel.isBackToView){ oldValue, newValue in
            displayMetricsView()
        }
        .navigationDestination(isPresented: $exerciseViewModel.endWorkout) {
            if exerciseViewModel.endWorkout{
                SummaryGeralView()// Quando Termina chama a view final
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

