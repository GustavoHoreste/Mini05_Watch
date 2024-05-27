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
    
    var body: some View {
        NavigationStack{
            List{
                HomeButton(name: "Avaliação", destination: SelectEvaluationView())
                    .padding(20)
                HomeButton(name: "Flexao", destination: PUView(viewModel: PUViewModel(model: PUModel())))
                    .padding(20)
                HomeButton(name: "Gráficos", destination: GraphView())
                    .padding(20)
                HomeButton(name: "Conquistas", destination: AchievementView())
                    .padding(20)
                Button("Save data") {
                    let data1 = RunData(date: Date(), totalTime: 90, totalDistance: 10, totalEnergy: 100, avgHeartRate: 110, avgSpeed: 8)
                    let data2 = RunData(date: Date(timeIntervalSinceNow: -60*60*24), totalTime: 120, totalDistance: 12, totalEnergy: 120, avgHeartRate: 110, avgSpeed: 9)
                    let data3 = RunData(date: Date(timeIntervalSinceNow: 60*60*24*2), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 105, avgSpeed: 10)
                    
                    context.insert(data1)
                    context.insert(data2)
                    context.insert(data3)
                    
                    print(runData.description)
                }
                Button("Delete all data") {
                    context.container.deleteAllData()
                    
                    print(runData.description)
                }
            }
            .listStyle(.carousel)
        }
        
    }
}

//#Preview {
//    HomeView(runData: [])
//}

