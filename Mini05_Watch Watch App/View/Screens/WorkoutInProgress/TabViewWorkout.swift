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
    
    @Environment(\.modelContext) var modelContext

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
            exerciseViewModel.allselectExercise = exerciseViewModel.selectExercise
            Task{
                await healthManager.startWorkout()
            }
            if !exerciseViewModel.selectExercise.contains(.summary){
                exerciseViewModel.selectExercise.append(.summary)
            }
            let _ = print("O valor tem que ser 4 da quantidade de exercicios: ", exerciseViewModel.selectExercise.count, " e esses sao os valores ", exerciseViewModel.selectExercise)
        }
        .onChange(of: exerciseViewModel.isBackToView){ oldValue, newValue in
            displayMetricsView()
        }
        .navigationDestination(isPresented: $exerciseViewModel.endWorkout) {
            if exerciseViewModel.endWorkout{
                SummaryGeralView()// Quando Termina chama a view final
            }
        }
        .onChange(of: exerciseViewModel.endWorkout) { _ , newValue in
            if newValue{
                saveData()
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
    TabViewWorkout()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}

