//
//  SummaryGeralView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import SwiftUI
import SwiftData

struct SummaryGeralView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    
    @Environment(\.modelContext) var modelContext
    
    @State var viewModel = SummaryGeralViewModel()
    
    @State private var navigateToNextView = false
    
    @State private var boolProvisorio = true
    @State private var boolProvisorio2 = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Relatório")
                        .myCustonFont(fontName: .sairaMedium, size: 25, valueScaleFactor: 0.8)
                    Text("Geral")
                        .myCustonFont(fontName: .sairaRegular, size: 18, valueScaleFactor: 0.8)
                        .foregroundStyle(.white)
                    SummaryGeralData(title: "Tempo", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.allselectExercise, addMedia: false), subValue: viewModel.arrayTimeValue(healthManager: healthManager, excViewModel: exerciseViewModel))
                    SummaryGeralData(title: "Frequência Cardíaca", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.allselectExercise, addMedia: true), subValue: viewModel.arrayHeartValue(enums: exerciseViewModel.allselectExercise))
                    SummaryGeralData(title: "Calorias Queimadas", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.allselectExercise, addMedia: false), subValue: viewModel.arrayCaloriesValue(enums: exerciseViewModel.allselectExercise))
                    if exerciseViewModel.allselectExercise.contains(.running12min) {
                        SummaryGeralData(title: "Velocidade", subTitle: ["Média Corrida", "Distância Percorrida"], subValue: viewModel.arraySpeedValue())
                    }
                    if exerciseViewModel.allselectExercise.contains(.abdominal) || exerciseViewModel.selectExercise.contains(.pushUps) {
                        SummaryGeralData(title: "Repetições", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.allselectExercise), subValue: viewModel.arrayRepsValue(enums: exerciseViewModel.allselectExercise))
                    }
                    Button(action: {
                        navigateToNextView.toggle()
                    }, label: {
                        Text("Voltar para a Home")
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
            .navigationDestination(isPresented: $navigateToNextView) {
                HomeView()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchData()
            healthManager.endSession()
        }
    }
}

#Preview {
    SummaryGeralView()
}
