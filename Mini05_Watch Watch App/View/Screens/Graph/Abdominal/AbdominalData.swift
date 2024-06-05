//
//  AbdominalData.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import Foundation
import SwiftData
import SwiftUI

enum AbdominalEnum: Identifiable {
    case totalTime
    case totalEnergy
    case avgHeartRate
    case repetitions
    
    var id: String {
        switch self {
        case .totalTime: return "Total Time"
        case .totalEnergy: return "Total Energy"
        case .avgHeartRate: return "Avg Heart Rate"
        case .repetitions: return "Repetitions"
        }
    }
    
    var keyPath: KeyPath<AbdominalData, Double> {
        switch self {
        case .totalTime: return \.totalTime
        case .totalEnergy: return \.totalEnergy
        case .avgHeartRate: return \.avgHeartRate
        case .repetitions: return \.repetitions
        }
    }
    
    var color: Color {
        switch self {
        case .totalTime: return .green
        case .totalEnergy: return .orange
        case .avgHeartRate: return .red
        case .repetitions: return .yellow
        }
    }
}

@Model
class AbdominalData: Identifiable {
    var date: Date
    var totalTime: Double
    var totalEnergy: Double
    var avgHeartRate: Double
    var repetitions: Double
    
    init(date: Date, totalTime: Double, totalEnergy: Double, avgHeartRate: Double, repetitions: Double) {
        self.date = date
        self.totalTime = totalTime
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.repetitions = repetitions
    }
}
