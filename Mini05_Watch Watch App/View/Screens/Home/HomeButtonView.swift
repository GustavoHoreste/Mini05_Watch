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
    
    private let buttons: [HomeButtonData] = [
        HomeButtonData(name: "Iniciar", destination: AnyView(SelectEvaluationView()), description: "Iniciar uma nova \navaliação", id: 0),
        HomeButtonData(name: "Avaliações", destination: AnyView(GraphView()), description: "Visualizar avaliações\n passadas", id: 1),
    ]
    
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
                    
                    //                Button("Save data") {
                    //                    let data1 = RunData(date: Date(), totalTime: 90, totalDistance: 10, totalEnergy: 100, avgHeartRate: 110, avgSpeed: 8)
                    //                let data2 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*2), totalTime: 120, totalDistance: 12, totalEnergy: 120, avgHeartRate: 110, avgSpeed: 9)
                    //                let data3 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*2+800), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 105, avgSpeed: 10)
                    //                let data4 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*3), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 105, avgSpeed: 10)
                    //                let data5 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*3+500), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 115, avgSpeed: 10)
                    //                let data6 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*3+800), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 175, avgSpeed: 10)
                    //                let data7 = PushUpData(date: Date(), totalTime: 80, totalEnergy: 20, avgHeartRate: 102, repetitions: 20)
                    //                let data8 = AbdominalData(date: Date(timeIntervalSinceNow: -60*60*24*30), totalTime: 90, totalEnergy: 26, avgHeartRate: 101, repetitions: 30)
                    //                let data9 = AbdominalData(date: Date(), totalTime: 60, totalEnergy: 16, avgHeartRate: 91, repetitions: 43)
                    //
                    //                context.insert(data1)
                    //                context.insert(data2)
                    //                context.insert(data3)
                    //                context.insert(data4)
                    //                context.insert(data5)
                    //                context.insert(data6)
                    //                context.insert(data7)
                    //                context.insert(data8)
                    //                context.insert(data9)
                    //
                    //                    print(runData.description)
                    //                }
                    //
                    //                Button("Delete all data") {
                    //                    context.container.deleteAllData()
                    //
                    //                    print(runData.description)
                    //                }
                }
                
                .onAppear {
                    exerciseViewModel.reseatAll()
                }
        }.navigationBarBackButtonHidden()
    }
}


#Preview {
    HomeView()
        .environmentObject(HealthKitManager())
}

struct HomeButtonData: Identifiable {
    let name: String
    let destination: AnyView
    let description: String
    let id: Int
}
