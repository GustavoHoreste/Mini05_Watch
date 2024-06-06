//
//  HeathKitManager.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 24/05/24.
//

import Foundation
import HealthKit


class HealthKitManager: NSObject, ObservableObject{
    ///dados de request
    private let healthStore: HKHealthStore = HKHealthStore()
    private let readData: Set<HKObjectType> = DataRequest.readData
    private let writeData: Set<HKSampleType> = DataRequest.writeData
    
    ///Dados de workout
    public var session: HKWorkoutSession?
    public var builder: HKLiveWorkoutBuilder?
    
    
    ////Variáveis de dados do HealthKit
    @Published private(set) var heartRate: Double = 0
    @Published private(set) var activeEnergyBurned: Double = 0
    @Published private(set) var distanceWalkingRunning: Double = 0
    @Published private(set) var runningSpeed: Double = 0
    @Published private(set) var runningPower: Double = 0
    @Published private(set) var bodyMass: Double = 0
    @Published private(set) var height: Double = 0
    @Published private(set) var generalTimeWorkout: String = ""
    @Published private(set) var repetitions: Double = 0
    
    
    ///timer descrecente
    @Published private(set) var forcePause:  Bool = false
    
    
    override init() { }
    
    
    public func requestPermission() async -> [HKObjectType: HKAuthorizationStatus]{
        do {
            try await healthStore.requestAuthorization(toShare: writeData, read: readData)
        } catch {
            print("Erro ao solicitar permissão: ", error.localizedDescription)
        }
        return verifyStatusPermission()
    }
    
    
    public func verifyStatusPermission() -> [HKObjectType: HKAuthorizationStatus] {
            var authorizationStatuses: [HKObjectType: HKAuthorizationStatus] = [:]
            for dataType in readData {
                let status = healthStore.authorizationStatus(for: dataType)
                authorizationStatuses[dataType] = status
            }
            return authorizationStatuses
    }
    

    public func startWorkout() async {
        if session?.state == .running || session?.state == .paused{
            print("Pausado")
            return
        }
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            session?.delegate = self
            builder?.delegate = self
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            try await executeExercise()
        } catch {
            print("Error em comecar workout: ", error.localizedDescription)
        }
    }
    
    private func executeExercise() async throws{
        guard let session = session, session.state == .notStarted else {
            print("Não autorizado ou sessão já iniciada.")
            return
        }
        let startDate = Date()
        self.session?.startActivity(with: startDate)
        try await builder?.beginCollection(at: startDate)
    }
    
    
    private func updateStatistics(_ statistics: HKStatistics){
        var unit: HKUnit?
        
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType(.activeEnergyBurned):
                unit = HKUnit.kilocalorie()
                self.activeEnergyBurned = statistics.sumQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.heartRate):
                unit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.averageQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.distanceWalkingRunning):
                unit = HKUnit.meter()
                self.distanceWalkingRunning = statistics.sumQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.runningSpeed):
                unit = HKUnit.meter().unitDivided(by: .second())
//                self.runningSpeed = statistics.mostRecentQuantity()?.doubleValue(for: unit!) ?? 0
                self.runningSpeed = statistics.averageQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.runningPower):
                unit = HKUnit.watt()
                self.runningPower = statistics.averageQuantity()?.doubleValue(for: unit!) ?? 0
            default:
                print("Valor inválido de statistics em updateStatistics")
            }
        }
    }
    
    
    ///Session Status
    public func endSession(){
        session?.end()
    }
    
    public func resumeSession(){
        session?.resume()
    }
    
    public func pauseSession(){
        session?.pause()
    }
    
    public func togglePauseOrStart(){
        print("estado ", session?.state.rawValue as Any)
        switch session?.state{ ///E do tipo `HKWorkoutSessionState`
        case .running: ///session em execucao
            self.pauseSession()
        case .paused: ///session pausada
            self.resumeSession()
        default:
            print("Estado desconhecido da sessão.")
        }
    }
    
    public func resetWorkoutData() {
        session = nil
        builder = nil
        
        heartRate = 0
        activeEnergyBurned = 0
        distanceWalkingRunning = 0
        runningSpeed = 0
        runningPower = 0
        bodyMass = 0
        height = 0
        self.forcePause = false
        
        print("Todos os dados do workout e do HealthKit foram resetados.")
    }
}



extension HealthKitManager: HKWorkoutSessionDelegate{
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Estado da session: ", toState.rawValue)
        
        if toState == .ended{
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    if error != nil{
                        print("Error: ", error?.localizedDescription as Any)
                    }else{
                        print("Session terminada")
                    }
                }
            }
        }
        
        
        if toState == .paused{
            DispatchQueue.main.async {
                self.forcePause = true
            }
        }
        
        if toState == .running{
            DispatchQueue.main.async {
                self.forcePause = false
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Deu error no delegate HKWorkoutSessionDelegate: ", error.localizedDescription)
    }
}

extension HealthKitManager: HKLiveWorkoutBuilderDelegate{
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        if self.forcePause{
            print("Pausad0...")
            return
        }
        for type in collectedTypes{
            guard let quantityType = type as? HKQuantityType, let statistics = workoutBuilder.statistics(for: quantityType) else {
                print("Valor de workoutBuilder e nil ou invalido")
                return
            }
            DispatchQueue.main.async {
                print("Rodando...")
            }
            self.updateStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
}
