//
//  HeathKitManager.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 24/05/24.
//

import Foundation
import HealthKit


class HeathKitManager: ObservableObject{
    private let healthStore: HKHealthStore = HKHealthStore()
    
    private let requestedData: Set = [
        HKQuantityType(.activeEnergyBurned)
    ]
    
    private func isHealthKitAvailable() -> Bool{
        return HKHealthStore.isHealthDataAvailable()
    }
    
    private func verifyStatusPermission() -> HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!)
    }
    
    public func requestPermission() async -> HKAuthorizationStatus{
        do {
            try await healthStore.requestAuthorization(toShare: requestedData, read: requestedData)
        } catch {
            print("Erro ao solicitar permissão: ", error.localizedDescription)
        }
        
        return verifyStatusPermission()
    }
}
