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
            let _ = print("criei")
            TimelineView(MetricsTimelineSchedule(from: healthManager.builder?.startDate ?? Date(), isPaused: healthManager.session?.state == .paused)) { value in
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Cronômetro")
                            .font(.callout)
                        
                        VStack(alignment: .leading){
                            ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0, showSubseconds: false)
                                .font(.system(size: 30))
                        }
                        HStack{
                            Text("Tempo de avaliação")
                                .font(.system(size: 10))
                            
                            ElapsedTimeView(elapsedTime: healthManager.builder?.elapsedTime(at: value.date) ?? 0,
                                            showSubseconds: value.cadence == .live)
                            
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


private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}


struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds, { oldValue, newValue in
                timeFormatter.showSubseconds = oldValue
            })
    }
}

class ElapsedTimeFormatter: Formatter {
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var showSubseconds = true

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}

#Preview {
    ExerciseProgressView()
        .environmentObject(HealthKitManager())
}

