//
//  HeathKitManager.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 24/05/24.
//

import Foundation
import HealthKit


struct DataRequest{
    static public var readData: Set = [
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.runningSpeed),
        HKQuantityType(.runningPower),
        HKQuantityType(.bodyMass),
        HKQuantityType(.height),
//        HKCharacteristicType(.dateOfBirth),
//        HKObjectType.activitySummaryType()
    ]
    
    static public let writeData: Set = [
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.runningSpeed),
        HKQuantityType(.runningPower),
        HKQuantityType(.bodyMass),
        HKQuantityType(.height),
        HKQuantityType.workoutType()
    ]
}


class HeathKitManager: NSObject, ObservableObject{
    ///dados de request
    private let healthStore: HKHealthStore = HKHealthStore()
    private let readData: Set<HKObjectType> = DataRequest.readData
    private let writeData: Set<HKSampleType> = DataRequest.writeData
    
    
    ///Dados de workout
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    
    ///Dado dos 
    @Published var heartRate: Double = 0
    @Published var nome: String = ""
    
    ///Reuquest
    public func verifyStatusPermission() -> [HKObjectType: HKAuthorizationStatus] {
            var authorizationStatuses: [HKObjectType: HKAuthorizationStatus] = [:]
            for dataType in readData {
                let status = healthStore.authorizationStatus(for: dataType)
                authorizationStatuses[dataType] = status
            }
            return authorizationStatuses
        }
    
    public func requestPermission() async -> [HKObjectType: HKAuthorizationStatus]{
        do {
            try await healthStore.requestAuthorization(toShare: writeData, read: readData)
        } catch {
            print("Erro ao solicitar permissão: ", error.localizedDescription)
        }
        return verifyStatusPermission()
    }
    
//    // Request authorization to access HealthKit.
//    func requestAuthorization() {
//        // The quantity type to write to the health store.
//        let typesToShare: Set = [
//            HKQuantityType.workoutType()
//        ]
//
//        // The quantity types to read from the health store.
//        let typesToRead: Set = [
//            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
//            HKObjectType.activitySummaryType()
//        ]
//
//        
//        
//        // Request authorization for those quantity types.
//        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
//            // Handle error.
//            if error != nil{
//                print(error?.localizedDescription as Any)
//            }
//            
//            print(success)
//        }
//        
//    }
    
    public func printAuthorizationStatuses() {
        let authorizationStatuses = verifyStatusPermission()
        for (dataType, status) in authorizationStatuses {
            print("\(dataType.identifier): \(status.rawValue)")
        }
    }

    ///start workout
    public func startWorkout() async {
        
        
//        let authorizationStatuses = verifyStatusPermission()
        
        
        print("qual o valor? ", HKHealthStore.isHealthDataAvailable())
        printAuthorizationStatuses()
//        guard !authorizationStatuses.values.contains(.sharingDenied),
//              !authorizationStatuses.values.contains(.notDetermined) else {
//            print("Permissão negada ou não determinada para alguns tipos de dados.")
//            return
//        }
        
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
            DispatchQueue.main.async{
                self.nome = String(error.localizedDescription)
            }
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
}

extension HeathKitManager: HKWorkoutSessionDelegate{
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
}

extension HeathKitManager: HKLiveWorkoutBuilderDelegate{
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes{
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            let statistics = workoutBuilder.statistics(for: quantityType)
            print("Estatistica: ", statistics?.quantityType as Any)

            if statistics?.quantityType == HKQuantityType.quantityType(forIdentifier: .heartRate){
                print("Estatistica: ", statistics?.quantityType as Any)
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                DispatchQueue.main.async{
                    self.heartRate = statistics?.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                }
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//        print("dentro de workoutBuilderDidCollectEvent", workoutBuilder.elapsedTime)
//        print("dentro de workoutBuilderDidCollectEvent", workoutBuilder as Any)
    }
}

//
//import Foundation
//import HealthKit
//
//class HeathKitManager: NSObject, ObservableObject {
//    var selectedWorkout: HKWorkoutActivityType? {
//        didSet {
//            guard let selectedWorkout = selectedWorkout else { return }
//            startWorkout(workoutType: selectedWorkout)
//        }
//    }
//
//    @Published var showingSummaryView: Bool = false {
//        didSet {
//            if showingSummaryView == false {
//                resetWorkout()
//            }
//        }
//    }
//
//    let healthStore = HKHealthStore()
//    var session: HKWorkoutSession?
//    var builder: HKLiveWorkoutBuilder?
//
//    // Start the workout.
//    func startWorkout(workoutType: HKWorkoutActivityType) {
//        let configuration = HKWorkoutConfiguration()
//        configuration.activityType = workoutType
//        configuration.locationType = .outdoor
//
//        // Create the session and obtain the workout builder.
//        do {
//            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
//            builder = session?.associatedWorkoutBuilder()
//        } catch {
//            // Handle any exceptions.
//            return
//        }
//
//        // Setup session and builder.
//        session?.delegate = self
//        builder?.delegate = self
//
//        // Set the workout builder's data source.
//        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
//                                                     workoutConfiguration: configuration)
//
//        // Start the workout session and begin data collection.
//        let startDate = Date()
//        session?.startActivity(with: startDate)
//        builder?.beginCollection(withStart: startDate) { (success, error) in
//            // The workout has started.
//        }
//    }
//
//    // Request authorization to access HealthKit.
//    func requestAuthorization() {
//        // The quantity type to write to the health store.
//        let typesToShare: Set = [
//            HKQuantityType.workoutType()
//        ]
//
//        // The quantity types to read from the health store.
//        let typesToRead: Set = [
//            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
//            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
//            HKObjectType.activitySummaryType()
//        ]
//
//        // Request authorization for those quantity types.
//        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
//            // Handle error.
//        }
//    }
//
//    // MARK: - Session State Control
//
//    // The app's workout state.
//    @Published var running = false
//
//    func togglePause() {
//        if running == true {
//            self.pause()
//        } else {
//            resume()
//        }
//    }
//
//    func pause() {
//        session?.pause()
//    }
//
//    func resume() {
//        session?.resume()
//    }
//
//    func endWorkout() {
//        session?.end()
//        showingSummaryView = true
//    }
//
//    // MARK: - Workout Metrics
//    @Published var averageHeartRate: Double = 0
//    @Published var heartRate: Double = 0
//    @Published var activeEnergy: Double = 0
//    @Published var distance: Double = 0
//    @Published var workout: HKWorkout?
//
//    func updateForStatistics(_ statistics: HKStatistics?) {
//        guard let statistics = statistics else { return }
//
//        DispatchQueue.main.async {
//            switch statistics.quantityType {
//            case HKQuantityType.quantityType(forIdentifier: .heartRate):
//                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
//                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
//                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
//            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
//                let energyUnit = HKUnit.kilocalorie()
//                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
//            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
//                let meterUnit = HKUnit.meter()
//                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
//            default:
//                return
//            }
//        }
//    }
//
//    func resetWorkout() {
//        selectedWorkout = nil
//        builder = nil
//        workout = nil
//        session = nil
//        activeEnergy = 0
//        averageHeartRate = 0
//        heartRate = 0
//        distance = 0
//    }
//}
//
//// MARK: - HKWorkoutSessionDelegate
//extension HeathKitManager: HKWorkoutSessionDelegate {
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
//                        from fromState: HKWorkoutSessionState, date: Date) {
//        DispatchQueue.main.async {
//            self.running = toState == .running
//        }
//
//        // Wait for the session to transition states before ending the builder.
//        if toState == .ended {
//            builder?.endCollection(withEnd: date) { (success, error) in
//                self.builder?.finishWorkout { (workout, error) in
//                    DispatchQueue.main.async {
//                        self.workout = workout
//                    }
//                }
//            }
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//
//    }
//}
//
//// MARK: - HKLiveWorkoutBuilderDelegate
//extension HeathKitManager: HKLiveWorkoutBuilderDelegate {
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//
//    }
//
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        for type in collectedTypes {
//            guard let quantityType = type as? HKQuantityType else {
//                return // Nothing to do.
//            }
//
//            let statistics = workoutBuilder.statistics(for: quantityType)
//
//            // Update the published values.
//            updateForStatistics(statistics)
//        }
//    }
//}
