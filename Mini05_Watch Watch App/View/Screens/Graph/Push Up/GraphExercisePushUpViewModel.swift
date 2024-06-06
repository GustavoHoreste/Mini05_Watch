//
//  GraphExercisePushUpViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class GraphExercisePushUpViewModel {
    var pushUpEnum: PushUpEnum
    
    var modelContext: ModelContext? = nil
    var pushData: [PushUpData] = []
    var graphData: [PushUpData] = []
    
    init(pushUpEnum: PushUpEnum) {
        self.pushUpEnum = pushUpEnum
    }
    
    func fetchData() {
        let fetchDescriptor = FetchDescriptor<PushUpData>(
            sortBy: [SortDescriptor(\PushUpData.date)]
        )
        
        pushData = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
    }
    
    func minYValue()-> Double {
        let yValues = graphData.map { $0[keyPath: pushUpEnum.keyPath] }
        return (yValues.min() ?? 0) - 10 < 0 ? 0 : (yValues.min() ?? 0) - 10
    }
    
    func maxYValue()-> Double {
        let yValues = graphData.map { $0[keyPath: pushUpEnum.keyPath] }
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
        let allValues = graphData.map { $0[keyPath: pushUpEnum.keyPath] }
        let total = allValues.reduce(0, +)
        let average = total / Double(allValues.count)
        return average
    }
    
    func separateByDay() {
        for (index, data) in pushData.enumerated() {
            let dateFormatted = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: data.date)
            
            let sameDateData = pushData.filter { Calendar.current.isDate($0.date, inSameDayAs: data.date) }
            
            if sameDateData.count == 1 && !graphData.map({ $0.date }).contains(data.date) {
                graphData.append(data)
            }
            
            if graphData.map({ $0.date }).contains(dateFormatted) || index + 1 == pushData.count {
                continue
            }
            
            if Calendar.current.isDate(data.date, inSameDayAs: pushData[index + 1].date) {
                let allValues = sameDateData.map { $0[keyPath: pushUpEnum.keyPath] }
                let total = allValues.reduce(0, +)
                let average = total / Double(allValues.count)
                let pushUpDataToShow = PushUpData(date: dateFormatted ?? Date(), totalEnergy: average, avgHeartRate: average, repetitions: average)
                
                graphData.append(pushUpDataToShow)
            }
        }
    }
    
    func complementValue()-> String {
        switch pushUpEnum {
        case .totalEnergy:
            return "kcal"
        case .avgHeartRate:
            return "bpm"
        case .repetitions:
            return ""
        }
    }
}
