//
//  SummaryView.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @Environment(\.dismiss) private var dismiss
    
    var exerciseType: WorkoutViewsEnun = .running12min
    
    @State private var navigateToNextView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Relatório")
                        .myCustonFont(fontName: .sairaMedium, size: 25, valueScaleFactor: 0.8)
                    Text(exerciseType.rawValue)
                        .myCustonFont(fontName: .sairaRegular, size: 18, valueScaleFactor: 0.8)
                        .foregroundStyle(.myOrange)
                    HStack {
                        SummaryDataComponent(title: "Tempo de corrida",
                                             value: "20:05")
                        SummaryDataComponent(title: "Tempo Recorde",
                                             value: "48:10")
                    }
                    HStack {
                        SummaryDataComponent(title: exerciseType.speedOrRep,
                                             value: "20Km/h")
                        SummaryDataComponent(title: exerciseType.speedOrRepRecord,
                                             value: "67Km/h")
                    }
                    HStack {
                        SummaryDataComponent(title: "Frequência cardíaca",
                                             value: "138bpm")
                        SummaryDataComponent(title: "Calorias queimadas",
                                             value: "300kcal")
                    }
                    Button(action: {
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


