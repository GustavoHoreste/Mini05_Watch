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
        HKCharacteristicType(.dateOfBirth),
        HKObjectType.activitySummaryType()

    ]
    
    static public let writeData: Set = [
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.runningSpeed),
        HKQuantityType(.runningPower),
        HKQuantityType(.bodyMass),
        HKQuantityType(.height),
    ]
}


class HeathKitManager: ObservableObject{
    ///dados de request
    private let healthStore: HKHealthStore = HKHealthStore()
    private let readData: Set<HKObjectType> = DataRequest.readData
    private let writeData: Set<HKQuantityType> = DataRequest.writeData
    
    ///Dados de workout
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    init(){}
    
    ///Reuquest
    private func verifyStatusPermission() -> HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!)//TODO: mudar para verificar cada valor
    }
    
    public func requestPermission() async -> HKAuthorizationStatus{
        do {
            try await healthStore.requestAuthorization(toShare: writeData, read: readData)
        } catch {
            print("Erro ao solicitar permissão: ", error.localizedDescription)
        }
        return verifyStatusPermission()
    }
    
    
    ///start workout
    public func startWorkout(){
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .americanFootball
        configuration.locationType = .outdoor
        
        
        do{
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        }catch{
            print("Error em comecar workout: ", error.localizedDescription)
        }
        
        
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
    }
}

extension HeathKitManager: HKWorkoutSessionDelegate{
    
}

extension HeathKitManager: HKLiveWorkoutBuilderDelegate{
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }

}
