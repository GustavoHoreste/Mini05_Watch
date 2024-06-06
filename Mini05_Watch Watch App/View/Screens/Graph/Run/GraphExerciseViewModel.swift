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
        return (yValues.min() ?? 0) - 10 < 0 ? 0 : (yValues.min() ?? 0) - 10
    }
    
    func maxYValue()-> Double {
        let yValues = graphData.map { $0[keyPath: runEnum.keyPath] }
        return (yValues.max() ?? 0) + 10
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
                let runDataToShow = RunData(date: dateFormatted ?? Date(), totalEnergy: average, avgHeartRate: average, avgSpeed: average)
                
                graphData.append(runDataToShow)
            }
        }
    }
    
    func complementValue()-> String {
        switch runEnum {
        case .totalEnergy:
            return "kcal"
        case .avgHeartRate:
            return "bpm"
        case .avgSpeed:
            return "Km/h"
        }
    }
    
}
