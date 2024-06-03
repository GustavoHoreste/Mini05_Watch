//
//  ExerciseProgressView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI


class ExerciseProgressViewModel: ObservableObject{
    @Published public var endWorkout: Bool = false
    @Published public var isBackToView: Bool = false
    @Published public var selectExercise: [WorkoutViewsEnun] = []
    @Published public var isDecrementingTimer: Bool = false
    @Published public var timerValue: Date = Date(){
        didSet{
            self.convertDateToDouble(timerValue)
        }
    }
    @Published private(set) var totalDuration: TimeInterval = 0

    public var startDate: Date?

    public func nextExercise(){
        if !selectExercise.isEmpty{
            self.selectExercise.removeFirst()
        }
    }
    
    public func toggleValueEnd(){
        self.endWorkout.toggle()
    }
    
    public func reseatAll(){
        self.selectExercise = []
        self.endWorkout = false
        self.isBackToView = false
//        self.isDecrementingTimer = false
    }
    
    public func backToView(){
        self.isBackToView = true
    }
    
    private func convertDateToDouble(_ date: Date){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        guard let hour = components.hour, let minute = components.minute, let second = components.second else{
            return
        }
        
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        
        self.totalDuration = totalSeconds
    }
    
    public func injectionStartDate(_ date: Date?){
        self.startDate = date
    }
    
    
    public func remainingTime(at date: Date) -> TimeInterval {
        guard let startDate = startDate else {
            return totalDuration
        }
        let elapsedTime = date.timeIntervalSince(startDate)
        return max(totalDuration - elapsedTime, 0)
    }
}

struct ExerciseProgressView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    @State private var callSummaryView: Bool = false

    var body: some View {
        NavigationStack{
            Group{
                switch exerciseViewModel.selectExercise.first ?? .pushUps{
                case .running12min:
                    MakeExerciseProgressView{
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
                    }
                case .pushUps, .abdominal:
                    MakeExerciseProgressView {
                        Text("Count")
                            .font(.title)
                    }
                default:
                    EmptyView()
                    let _ = print("view vazia")
                }
            }
            .onAppear{
                Task{
                    await healthManager.startWorkout()
                }
                if exerciseViewModel.selectExercise.first == .summary{
                    self.callSummaryView = true
                }
                exerciseViewModel.injectionStartDate(healthManager.builder?.startDate ?? Date())
            }
            .navigationDestination(isPresented: $callSummaryView) {
                withAnimation {
                    SummaryView()
                }
            }
        }
    }
}

struct HeartAndCaloriesViewComponemt: View {
    @EnvironmentObject private var healthManager: HealthKitManager

    var body: some View {
        VStack{
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "cal",
                                systemImage: "flame.fill",
                                nameSection: "Calorias",
                                value: healthManager.activeEnergyBurned,
                                withSimbol: true))
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "bpm",
                                systemImage: "heart.fill",
                                nameSection: "Frequência Cardíaca",
                                value: healthManager.heartRate,
                                withSimbol: true))
        }
    }
}


struct MakeExerciseProgressView<T: View>: View {
    let content: T
    
    init(@ViewBuilder _ content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        TabView {
            TimerWorkoutView().tag(0)
            self.content.tag(1)
            HeartAndCaloriesViewComponemt().tag(1)
        }.tabViewStyle(.carousel)
    }
}



#Preview {
    ExerciseProgressView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}

