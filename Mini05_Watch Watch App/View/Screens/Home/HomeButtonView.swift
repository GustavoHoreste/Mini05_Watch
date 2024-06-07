//
//  HomeView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    
    private let buttons: [HomeButtonData] = [
        HomeButtonData(name: "Iniciar", destination: AnyView(SelectEvaluationView()), description: "Iniciar uma nova \navaliação", id: 0),
        HomeButtonData(name: "Avaliações", destination: AnyView(GraphChooseView()), description: "Visualizar avaliações\n passadas", id: 1),
        HomeButtonData(name: "Calibragem", destination: AnyView(CalibrationView()), description: "", id: 2)
    ]
    
    @AppStorage("saveData") var savedData = false
    
    var body: some View {
        NavigationStack{
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHStack{
                        ForEach(buttons, id: \.name) { button in
                            VStack{
                                if button.id == 0 {
                                    Text("Ascender")
                                        .myCustonFont(fontName: .sairaMedium, size: 20, valueScaleFactor: 12)
                                        .foregroundStyle(Color("myOrange"))
                                        .padding(.top, -9)
                                        .padding(.trailing, 87)
                                        .padding(.bottom, -15)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }
                                    Text(button.description)
                                        .myCustonFont(fontName: .sairaRegular, size: 14, valueScaleFactor: 0)
                                        .multilineTextAlignment(.leading)
                                        .padding(.trailing, 60)
                                        .padding(.bottom, -5)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }
                                } else if button.id == 1 {
                                    Text(button.description)
                                        .myCustonFont(fontName: .sairaRegular, size: 14, valueScaleFactor: 0)
                                        .multilineTextAlignment(.trailing)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                        }

                                }
                                HStack{
                                    HomeButton(name: button.name, destination: button.destination)
                                        .scrollTransition(axis: .horizontal) { content, phase in
                                            content
                                                .scaleEffect(x: phase.isIdentity ? 1 : 0.4,
                                                             y: phase.isIdentity ? 1 : 0.4)
                                                .offset(x: phase.isIdentity ? 1 : 2,
                                                        y: phase.isIdentity ? 1 : 30)
                                                .opacity(phase.isIdentity ? 1 : 0.2)
                                            
                                        }
                                        .padding()
                                        .padding(.leading, (button.id != 0) ? 1 : -1)
                                        .padding(.trailing, (button.id == 0) ? 1 : 20)
                                }
                            }
                        }
                        
                    }
                }
        }
        .background(.bg)
        .navigationBarBackButtonHidden()
            .onAppear {
                healthManager.resetWorkoutData()
                exerciseViewModel.reseatAll()
                saveData()
            }
    }
    
    private func saveData() {
        if !savedData {
            savedData = true
            let data1 = RunData(date: Date(timeIntervalSinceNow: -60*60*24), totalEnergy: 10, avgHeartRate: 100, avgSpeed: 110, totalDistance: 8)
            let data2 = RunData(date: Date(timeIntervalSinceNow: -60*60*24*2), totalEnergy: 12, avgHeartRate: 143, avgSpeed: 8, totalDistance: 1)
            let data3 = RunData(date: Date(timeIntervalSinceNow: -60*60*24*3+800),totalEnergy: 9, avgHeartRate: 150, avgSpeed: 10, totalDistance: 2)
            let data4 = RunData(date: Date(timeIntervalSinceNow: -60*60*24*4), totalEnergy: 9, avgHeartRate: 133, avgSpeed: 11, totalDistance: 3)
            let data5 = RunData(date: Date(timeIntervalSinceNow: -60*60*24*5+500), totalEnergy: 9, avgHeartRate: 125, avgSpeed: 13, totalDistance: 4)
            let data6 = RunData(date: Date(timeIntervalSinceNow: -60*60*24*6+800) ,totalEnergy: 9, avgHeartRate: 141, avgSpeed: 15, totalDistance: 5)
            let data7 = PushUpData(date: Date(timeIntervalSinceNow: -60*60*24), totalEnergy: 6, avgHeartRate: 102, repetitions: 15)
            let data8 = AbdominalData(date: Date(timeIntervalSinceNow: -60*60*24*2), totalEnergy: 26, avgHeartRate: 101, repetitions: 30)
            let data9 = AbdominalData(date: Date(timeIntervalSinceNow: -60*60*24*4), totalEnergy: 16, avgHeartRate: 91, repetitions: 43)
            let data10 = PushUpData(date: Date(timeIntervalSinceNow: -60*60*24*2), totalEnergy: 11, avgHeartRate: 118, repetitions: 20)
            
            context.insert(data1)
            context.insert(data2)
            context.insert(data3)
            context.insert(data4)
            context.insert(data5)
            context.insert(data6)
            context.insert(data7)
            context.insert(data8)
            context.insert(data9)
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(ExerciseProgressViewModel())
        .environmentObject(HealthKitManager())
}

struct HomeButtonData: Identifiable {
    let name: String
    let destination: AnyView
    let description: String
    let id: Int
}
