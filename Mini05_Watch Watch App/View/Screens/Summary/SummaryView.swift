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
                                             value: "\(Int(healthManager.calories))kcal")
                    }
                    Button(action: {
                        healthManager.calories = 0
                        healthManager.resumeSession()
                        exerciseViewModel.callSumaryView = false
                        exerciseViewModel.nextExercise()
                        exerciseViewModel.startDate = nil
                        exerciseViewModel.backToView()
                        self.dismiss()
                    }, label: {
                        Text("Iniciar próximo exercício")
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                    })
                    .myCustonFont(fontName: .sairaMedium, size: 12, valueScaleFactor: 0.8)
                    .padding()
                    .background(.myOrange)
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
}


