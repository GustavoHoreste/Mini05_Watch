//
//  ExerciseProgressView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ExerciseProgressView: View {
    @EnvironmentObject private var healthManager: HealthKitManager

    var body: some View {
        MakeExerciseProgressView {
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "cal",
                                systemImage: "flame.fill",
                                nameSection: "Calorias",
                                value: healthManager.activeEnergyBurned,
                                withSimbol: true))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "m/s",
                                systemImage: "bolt.fill",
                                nameSection: "Velocidade",
                                value: healthManager.runningSpeed,
                                withSimbol: true))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "km",
                                systemImage: "map.fill",
                                nameSection: "Distância",
                                value: healthManager.distanceWalkingRunning,
                                withSimbol: false))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "bpm",
                                systemImage: "heart.fill",
                                nameSection: "Frequência Cardíaca",
                                value: healthManager.heartRate,
                                withSimbol: true))
        }.onAppear {
            Task{
                await healthManager.startWorkout()
            }
        }
    }
}

//intencao e criar view diferentes de acordo com o exercicio
struct MakeExerciseProgressView<T: View>: View {
    @EnvironmentObject var healthManager: HealthKitManager
    
    let content: T
    
    init(@ViewBuilder _ content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack{
            TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Cronômetro")
                            .font(.callout)
                        
                        ElapsedTimeView(elapsedTime: healthManager.remainingTime(at: value.date), showSubseconds: false)
                            .font(.system(size: 30))
                        
                        HStack{
                            Text("Tempo de avaliação")
                                .font(.system(size: 10))
                           
                            ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: value.cadence == .live)

                            
                        }.frame(width: 180, height: 30)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 2)
                        }
                        
                        content
                        
                    }.navigationTitle("Defult")//mudar de acordo com o nome do exercicio
                }
            }
        }
    }
}

#Preview {
    ExerciseProgressView()
        .environmentObject(HealthKitManager())
}

