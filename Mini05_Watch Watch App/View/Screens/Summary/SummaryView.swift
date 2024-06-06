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
                                             value: "\(healthManager.runningSpeed)")
                        SummaryDataComponent(title: exerciseViewModel.selectExercise.first!.speedOrRepRecord,
                                             value: "67Km/h")
                    }
                    HStack {
                        SummaryDataComponent(title: "Frequência cardíaca",
                                             value: "\(healthManager.heartRate)")
                        SummaryDataComponent(title: "Calorias queimadas",
                                             value: "\(healthManager.activeEnergyBurned)")
                    }
                    Button(action: {
                        navigateToNextView.toggle()
                    }, label: {
                        Text("Iniciar próximo exercício")
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                    })
                    .myCustonFont(fontName: .sairaMedium, size: 12, valueScaleFactor: 0.8)
                    .frame(width: .infinity)
                    .padding()
                    .background(.myOrange)
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .onDisappear{
                    healthManager.resetWorkoutData()
                    exerciseViewModel.reseatAll()
                }


            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $navigateToNextView) { 
                SummaryView()
            }
        }
    }
}

//#Preview {
//    SummaryView(exerciseType: .running12min)
//}

