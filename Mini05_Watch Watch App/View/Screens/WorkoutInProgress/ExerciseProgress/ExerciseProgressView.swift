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
    @Published public var selectExercise: [WorkoutViewsEnun] = []{
        didSet{
            print("Valor e: ", self)
        }
    }

    
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
    }
    
    public func backToView(){
        self.isBackToView = true
    }
}

struct ExerciseProgressView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @EnvironmentObject private var healthManager: HealthKitManager
    @State private var callSummaryView: Bool = false

    var body: some View {
        NavigationStack{
            ScrollView {
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
                }
            }
            .navigationTitle(exerciseViewModel.selectExercise.first?.rawValue ?? "nil")
            .onAppear{
                if exerciseViewModel.selectExercise.first == .summary{
                    self.callSummaryView = true
                }
                Task{
                    await healthManager.startWorkout()
                }
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
        NavigationStack{
            ScrollView {
                VStack{
                    TimerWorkoutView()
                    self.content
                    HeartAndCaloriesViewComponemt()
                }
            }
        }
    }
}



#Preview {
    ExerciseProgressView()
        .environmentObject(HealthKitManager())
        .environmentObject(ExerciseProgressViewModel())
}

