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
    
    
    ///timer descrecente
    @Published private(set) var totalDuration: TimeInterval = 20
    
    override init() { }
    
    
    public func remainingTime(at date: Date) -> TimeInterval {
        guard let startDate = builder?.startDate else {
            return totalDuration
        }
        let elapsedTime = date.timeIntervalSince(startDate)
        return max(totalDuration - elapsedTime, 0)
    }
    
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
    

    //TODO: Mudar de onde a funcao e chamada
    ///start workout
    public func startWorkout() async {
        
        if session?.state.rawValue == 4 || session?.state.rawValue == 2{
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
    
    
    ///Query de pesso e altura -> Utilizado no imc
    public func queryUserData(_ type: HKQuantityTypeIdentifier) async -> String{
        let type = HKQuantityType(type)
        var results: [HKQuantitySample] = []
        
        let description = HKSampleQueryDescriptor(predicates: [.quantitySample(type: type)], sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)], limit: 1)
        
        do{
            results = try await description.result(for: healthStore)
        }catch{
            print("error in queryData: ", error.localizedDescription)
        }
        
        for result in results{
            print(result.quantity)
            return String("\(result.quantity)")
        }
        return "nil"
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
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.distanceWalkingRunning):
                unit = HKUnit.meter()
                self.distanceWalkingRunning = statistics.sumQuantity()?.doubleValue(for: unit!) ?? 0
            case HKQuantityType(.runningSpeed):
                unit = HKUnit.meter().unitDivided(by: .second())
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
        switch session?.state.rawValue{ ///E do tipo `HKWorkoutSessionState`
        case 2: ///session em execucao
            self.pauseSession()
        case 4: ///session pausada
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
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Deu error no delegate HKWorkoutSessionDelegate: ", error.localizedDescription)
    }
}

extension HealthKitManager: HKLiveWorkoutBuilderDelegate{
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes{
            guard let quantityType = type as? HKQuantityType, let statistics = workoutBuilder.statistics(for: quantityType) else {
                print("Valor de workoutBuilder e nil ou invalido")
                return
            }
            self.updateStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
}
