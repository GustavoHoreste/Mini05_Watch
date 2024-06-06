//
//  SummaryView.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @Environment(\.dismiss) private var dismiss
    
//    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel = SummaryViewModel()
    
    @State private var navigateToNextView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Relatório")
                        .myCustonFont(fontName: .sairaMedium, size: 25, valueScaleFactor: 0.8)
                    Text(exerciseViewModel.selectExercise.first!.rawValue)
                        .myCustonFont(fontName: .sairaRegular, size: 18, valueScaleFactor: 0.8)
                        .foregroundStyle(.myOrange)
                    HStack {
                        SummaryDataComponent(title: "Tempo de exercício",
                                             value: "20:05")
                        SummaryDataComponent(title: "Tempo Recorde",
                                             value: "48:10")
                    }
                    HStack {
                        SummaryDataComponent(title: exerciseViewModel.selectExercise.first!.speedOrRep,
                                             value: "\(Int(healthManager[keyPath: exerciseViewModel.selectExercise.first!.keyPath]))")
                        SummaryDataComponent(title: exerciseViewModel.selectExercise.first!.speedOrRepRecord,
                                             value: viewModel.speedOrRepRecord(enun: exerciseViewModel.selectExercise.first!, value: healthManager[keyPath: exerciseViewModel.selectExercise.first!.keyPath]))
                    }
                    HStack {
                        SummaryDataComponent(title: "Frequência cardíaca",
                                             value: "\(Int(healthManager.heartRate))bpm")
                        SummaryDataComponent(title: "Calorias queimadas",
                                             value: "\(Int(healthManager.activeEnergyBurned))kcal")
                    }
                    Button(action: {
//                        saveData()
                        exerciseViewModel.nextExercise()
                        healthManager.resumeSession()
                        exerciseViewModel.backToView()
                        self.dismiss()
                    }, label: {
                        Text("Iniciar próximo exercício")
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                    })
                    .myCustonFont(fontName: .sairaMedium, size: 12, valueScaleFactor: 0.8)
//                    .frame(width: .infinity)
                    .padding()
                    .background(.myOrange)
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .onAppear{
                    
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
//    private func saveData() {
//        print("SELECT EXERCISE FIRST: \(exerciseViewModel.selectExercise.first!)")
//        switch exerciseViewModel.selectExercise.first! {
//        case .running12min:
//            let runData = RunData(date: Date(), totalTime: exerciseViewModel.totalDuration!, totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, avgSpeed: healthManager.runningSpeed)
//            
//            modelContext.insert(runData)
//        case .pushUps:
//            let pushUpData = PushUpData(date: Date(), totalTime: exerciseViewModel.totalDuration!, totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, repetitions: healthManager.repetitions)
//            
//            modelContext.insert(pushUpData)
//        default:
//            let abdominalData = AbdominalData(date: Date(), totalTime: exerciseViewModel.totalDuration!, totalEnergy: healthManager.activeEnergyBurned, avgHeartRate: healthManager.heartRate, repetitions: healthManager.repetitions)
//            
//            modelContext.insert(abdominalData)
//        }
//    }
    
}


