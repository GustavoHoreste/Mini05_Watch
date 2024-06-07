//
//  SummaryGeralViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class SummaryGeralViewModel {
    var modelContext: ModelContext? = nil
    
    var runData: [RunData] = []
    var pushUpData: [PushUpData] = []
    var abdominalData: [AbdominalData] = []
    
    func fetchData() {
        let fetchDescriptor = FetchDescriptor<AbdominalData>(
            sortBy: [SortDescriptor(\AbdominalData.date)]
        )
        let fetchDescriptorRun = FetchDescriptor<RunData>(
            sortBy: [SortDescriptor(\RunData.date)]
        )
        let fetchDescriptorPush = FetchDescriptor<PushUpData>(
            sortBy: [SortDescriptor(\PushUpData.date)]
        )
        
        abdominalData = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
        runData = (try? (modelContext?.fetch(fetchDescriptorRun) ?? [])) ?? []
        pushUpData = (try? (modelContext?.fetch(fetchDescriptorPush) ?? [])) ?? []
    }
    
    func arraySubTitle(enums: [WorkoutViewsEnun], addMedia: Bool)-> [String] {
        var array: [String] = [addMedia ? "Média Total" : "Total"]
        
        for enun in enums {
            array.append(enun.rawValue)
        }
        
        return array
    }
    
    func arraySubTitle(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        
        for enun in enums {
            array.append(enun.rawValue)
        }
        
        return array
    }
    
    func arrayTimeValue(healthManager: HealthKitManager, excViewModel: ExerciseProgressViewModel)-> [String] {
        var array: [String] = []
        var dataArray: [Double] = []
        
        for enun in excViewModel.allselectExercise {
            dataArray.append(healthManager[keyPath: enun.keyPathTimer])
        }
        
        let total = dataArray.reduce(0, +)
        array.append(Int(healthManager.timerFinishGeneral).formatTime())
        
        for data in dataArray {
            array.append(Int(data).formatTime())
        }
        
        return array
    }
    
    func arrayHeartValue(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        var dataArray: [Double] = []
        
        let run = runData.last ?? RunData(date: Date(), totalEnergy: 0, avgHeartRate: 0, avgSpeed: 0)
        let push = pushUpData.last ?? PushUpData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        let abd = abdominalData.last ?? AbdominalData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        
        let lastRun = run.avgHeartRate
        let lastPush = push.avgHeartRate
        let lastAbd = abd.avgHeartRate
        
        for enun in enums {
            switch enun {
            case .running12min: dataArray.append(lastRun)
            case .pushUps: dataArray.append(lastPush)
            default: dataArray.append(lastAbd)
            }
        }
        
        let total = dataArray.reduce(0, +)
        let average = total / Double(dataArray.count)
        
        array.append("\(Int(average.isNaN ? 0 : average))bpm")
        
        for enun in enums {
            switch enun {
            case .running12min: array.append("\(Int(lastRun))bpm")
            case .pushUps: array.append("\(Int(lastPush))bpm")
            default: array.append("\(Int(lastAbd))bpm")
            }
        }
        
        return array
    }
    
    func arrayCaloriesValue(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        var dataArray: [Double] = []
        
        let run = runData.last ?? RunData(date: Date(), totalEnergy: 0, avgHeartRate: 0, avgSpeed: 0)
        let push = pushUpData.last ?? PushUpData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        let abd = abdominalData.last ?? AbdominalData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        
        let lastRun = run.totalEnergy
        let lastPush = push.totalEnergy
        let lastAbd = abd.totalEnergy
        
        for enun in enums {
            switch enun {
            case .running12min: dataArray.append(lastRun)
            case .pushUps: dataArray.append(lastPush)
            default: dataArray.append(lastAbd)
            }
        }
        
        let total = dataArray.reduce(0, +)
        
        array.append("\(String(format: "%.1f", total.isNaN ? 0 : total))kcal")

        for enun in enums {
            switch enun {
            case .running12min: array.append("\(String(format: "%.1f", total.isNaN ? 0 : lastRun))kcal")
            case .pushUps: array.append("\(String(format: "%.1f", total.isNaN ? 0 : lastPush))kcal")
            default: array.append("\(String(format: "%.1f", total.isNaN ? 0 : lastAbd))kcal")
            }
        }
        
        return array
    }
    
    func arraySpeedValue()-> [String] {
        let run = runData.last ?? RunData(date: Date(), totalEnergy: 0, avgHeartRate: 0, avgSpeed: 0)
        let lastRun = run.avgSpeed
        
        return ["\(Int(lastRun))Km/h"]
    }
    
    func arrayRepsValue(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        let push = pushUpData.last ?? PushUpData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        let abd = abdominalData.last ?? AbdominalData(date: Date(), totalEnergy: 0, avgHeartRate: 0, repetitions: 0)
        
        let lastPush = push.repetitions
        let lastAbd = abd.repetitions
        
        for enun in enums {
            switch enun {
            case .pushUps: array.append("\(Int(lastPush))")
            default: array.append("\(Int(lastAbd))")
            }
        }
        
        return array
    }
    
}
