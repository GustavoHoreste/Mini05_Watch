//
//  GraphExerciseViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 29/05/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class GraphExerciseViewModel {
    // ---- APAGAR DEPOIS -----
    var testeGrafico: [RunData] = [RunData(date: Date(timeIntervalSinceNow: -60*60*24*3), totalTime: 90, totalDistance: 10, totalEnergy: 100, avgHeartRate: 122, avgSpeed: 8),
                                   RunData(date: Date(), totalTime: 90, totalDistance: 10, totalEnergy: 100, avgHeartRate: 110, avgSpeed: 8),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24), totalTime: 120, totalDistance: 12, totalEnergy: 120, avgHeartRate: 120, avgSpeed: 9),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*2), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 145, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*4), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 115, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*7), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 155, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*10), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 165, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*11), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 135, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*13), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 143, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*14), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 173, avgSpeed: 10),
                                   RunData(date: Date(timeIntervalSinceNow: 60*60*24*17), totalTime: 180 ,totalDistance: 9, totalEnergy: 90, avgHeartRate: 121, avgSpeed: 10),
    ]
    //---------------------------
    
    var runEnum: RunEnum
    
    var modelContext: ModelContext? = nil
    var runData: [RunData] = []
    var graphData: [RunData] = []
    
    init(runEnum: RunEnum) {
        self.runEnum = runEnum
    }
    
    func fetchData() {
        let fetchDescriptor = FetchDescriptor<RunData>(
            sortBy: [SortDescriptor(\RunData.date)]
        )
        
        runData = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
    }
    
    func minYValue()-> Double {
        let yValues = graphData.map { $0[keyPath: runEnum.keyPath] }
        return (yValues.min() ?? 0) - 20
    }
    
    func maxYValue()-> Double {
        let yValues = graphData.map { $0[keyPath: runEnum.keyPath] }
        return (yValues.max() ?? 0) + 20
    }
    
    func minXDate()-> Date {
        let dates = graphData.map { $0.date }
        return Calendar.current.date(byAdding: .hour, value: -12, to: dates.min() ?? Date()) ?? Date()
    }
    
    func maxXDate()-> Date {
        let dates = graphData.map { $0.date }
        return Calendar.current.date(byAdding: .hour, value: 12, to: dates.max() ?? Date()) ?? Date()
    }
    
    func getAverage()-> Double {
        let allValues = graphData.map { $0[keyPath: runEnum.keyPath] }
        let total = allValues.reduce(0, +)
        let average = total / Double(allValues.count)
        return average
    }
    
    func separateByDay() {
        for (index, data) in runData.enumerated() {
            let dateFormatted = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: data.date)
            
            let sameDateData = runData.filter { Calendar.current.isDate($0.date, inSameDayAs: data.date) }
            
            if sameDateData.count == 1 && !graphData.map({ $0.date }).contains(data.date) {
                graphData.append(data)
            }
            
            if graphData.map({ $0.date }).contains(dateFormatted) || index + 1 == runData.count {
                continue
            }
            
            if Calendar.current.isDate(data.date, inSameDayAs: runData[index + 1].date) {
                let allValues = sameDateData.map { $0[keyPath: runEnum.keyPath] }
                let total = allValues.reduce(0, +)
                let average = total / Double(allValues.count)
                let runDataToShow = RunData(date: dateFormatted ?? Date(), totalTime: average, totalDistance: average, totalEnergy: average, avgHeartRate: average, avgSpeed: average)
                
                graphData.append(runDataToShow)
            }
        }
    }
    
}
