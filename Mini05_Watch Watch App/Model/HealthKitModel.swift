//
//  HealthKitModel.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 26/05/24.
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

struct SectionExerciseModel {
    let exetensionSection: String
    let systemImage: String
//    let nameSection: String
    let value: Double
//    let withSimbol: Bool
}
