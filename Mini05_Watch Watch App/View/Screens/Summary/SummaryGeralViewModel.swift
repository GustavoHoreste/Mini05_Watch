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
    
    var lastRunData: RunData?
    var lastPushUpData: PushUpData?
    var lastAbdominalData: AbdominalData?
    
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
        
        let abdominalData = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
        let runData = (try? (modelContext?.fetch(fetchDescriptorRun) ?? [])) ?? []
        let pushData = (try? (modelContext?.fetch(fetchDescriptorPush) ?? [])) ?? []
        
        lastRunData = runData.last
        lastPushUpData = pushData.last
        lastAbdominalData = abdominalData.last
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
    
    func arrayHeartValue(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        var dataArray: [Double] = []
        let lastRun = lastRunData!.avgHeartRate
        let lastPush = lastPushUpData!.avgHeartRate
        let lastAbd = lastAbdominalData!.avgHeartRate
        
        for enun in enums {
            switch enun {
            case .running12min: dataArray.append(lastRun)
            case .pushUps: dataArray.append(lastPush)
            default: dataArray.append(lastAbd)
            }
        }
        
        let total = dataArray.reduce(0, +)
        let average = total / Double(dataArray.count)
        
        array.append("\(Int(average))")
        
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
        let lastRun = lastRunData!.totalEnergy
        let lastPush = lastPushUpData!.totalEnergy
        let lastAbd = lastAbdominalData!.totalEnergy
        
        for enun in enums {
            switch enun {
            case .running12min: dataArray.append(lastRun)
            case .pushUps: dataArray.append(lastPush)
            default: dataArray.append(lastAbd)
            }
        }
        
        let total = dataArray.reduce(0, +)
        let average = total / Double(dataArray.count)
        
        array.append("\(Int(average))")
        
        for enun in enums {
            switch enun {
            case .running12min: array.append("\(Int(lastRun))kcal")
            case .pushUps: array.append("\(Int(lastPush))kcal")
            default: array.append("\(Int(lastAbd))kcal")
            }
        }
        
        return array
    }
    
    func arraySpeedValue()-> [String] {
        let lastRun = lastRunData!.avgSpeed
        return ["\(Int(lastRun))Km/h"]
    }
    
    func arrayRepsValue(enums: [WorkoutViewsEnun])-> [String] {
        var array: [String] = []
        let lastPush = lastPushUpData!.repetitions
        let lastAbd = lastAbdominalData!.repetitions
        
        for enun in enums {
            switch enun {
            case .pushUps: array.append("\(Int(lastPush))")
            default: array.append("\(Int(lastAbd))")
            }
        }
        
        return array
    }
    
}
