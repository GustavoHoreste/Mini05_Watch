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
    @Query(sort: \RunData.date) var runData: [RunData]
    
    private let buttons: [HomeButtonData] = [
        HomeButtonData(name: "Iniciar", destination: AnyView(SelectEvaluationView()), description: "Iniciar uma nova avaliação"),
        HomeButtonData(name: "Avaliações", destination: AnyView(GraphView()), description: "Visualizar avaliações passadas"),
        HomeButtonData(name: "Conquistas", destination: AnyView(AchievementView()), description: "Ver conquistas")
    ]
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Ascender")
                Spacer()
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack{
                    Rectangle()
                        .frame(width: 30)
                        .foregroundStyle(.clear)
                    
                    ForEach(buttons, id: \.name) { button in
                        
                        HomeButton(name: button.name, destination: button.destination)
                            .scrollTransition(axis: .horizontal) { content, phase in
                                content
                                    .scaleEffect(x: phase.isIdentity ? 1 : 0.4,
                                                 y: phase.isIdentity ? 1 : 0.4)
                                    .offset(x: phase.isIdentity ? 1 : 2,
                                            y: phase.isIdentity ? 1 : 30)
                                
                            }
                            .padding(10)
                    }
                    Rectangle()
                        .frame(width: 30)
                        .foregroundStyle(.clear)
                }
                
                //                Button("Save data") {
                //                    let data1 = RunData(date: Date(), totalTime: 90, totalDistance: 10, totalEnergy: 100, avgHeartRate: 110, avgSpeed: 8)
                //                    let data2 = RunData(date: Date(timeIntervalSinceNow: -60*60*24), totalTime: 120, totalDistance: 12, totalEnergy: 120, avgHeartRate: 110, avgSpeed: 9)
                //                    let data3 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*2), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 105, avgSpeed: 10)
                //
                //                    context.insert(data1)
                //                    context.insert(data2)
                //                    context.insert(data3)
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
        }
            
        }
    }
    
    
}


#Preview {
    HomeView()
        .environmentObject(HealthKitManager())
}

struct HomeButtonData {
    let name: String
    let destination: AnyView
    let description: String
}
