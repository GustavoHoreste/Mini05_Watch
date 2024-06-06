//
//  SummaryGeralView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import SwiftUI
import SwiftData

struct SummaryGeralView: View {
//    @EnvironmentObject private var healthManager: HealthKitManager
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
                    // MUDAR PARA O ARRAY COM TODOS OS EXERCICIOS SELECIONADOS AQUI
                    SummaryGeralData(title: "Tempo", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.selectExercise, addMedia: false), subValue: ["40:05", "20:05", "10:00", "10:00"])
                    // MUDAR PARA O ARRAY COM TODOS OS EXERCICIOS SELECIONADOS AQUI
                    SummaryGeralData(title: "Frequência Cardíaca", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.selectExercise, addMedia: true), subValue: viewModel.arrayHeartValue(enums: exerciseViewModel.selectExercise))
                    // MUDAR PARA O ARRAY COM TODOS OS EXERCICIOS SELECIONADOS AQUI
                    SummaryGeralData(title: "Calorias Queimadas", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.selectExercise, addMedia: false), subValue: viewModel.arrayCaloriesValue(enums: exerciseViewModel.selectExercise))
                    if exerciseViewModel.selectExercise.contains(.running12min) {
                        SummaryGeralData(title: "Velocidade", subTitle: ["Média Corrida"], subValue: viewModel.arraySpeedValue())
                    }
                    if exerciseViewModel.selectExercise.contains(.abdominal) || exerciseViewModel.selectExercise.contains(.pushUps) {
                        SummaryGeralData(title: "Repetições", subTitle: viewModel.arraySubTitle(enums: exerciseViewModel.selectExercise), subValue: ["30", "52"])
                    }
                    Button(action: {
                        navigateToNextView.toggle()
                    }, label: {
                        Text("Voltar para a Home")
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
            }
            .navigationDestination(isPresented: $navigateToNextView) {
                HomeView()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchData()
        }
    }
}

#Preview {
    SummaryGeralView()
}
