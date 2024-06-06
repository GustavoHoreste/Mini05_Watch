//
//  RunData.swift
//  Mini05_Watch Watch App
//
//  Created by AndrÃ© Felipe Chinen on 24/05/24.
//

import Foundation
import SwiftData
import SwiftUI

enum RunEnum: Identifiable {
    case totalTime
    case totalDistance
    case totalEnergy
    case avgHeartRate
    case avgSpeed
    
    var id: String {
        switch self {
        case .totalTime: return "Total Time"
        case .totalDistance: return "Total Distance"
        case .totalEnergy: return "Total Energy"
        case .avgHeartRate: return "Avg Heart Rate"
        case .avgSpeed: return "Avg Speed"
        }
    }
    
    var keyPath: KeyPath<RunData, Double> {
        switch self {
        case .totalTime: return \.totalTime
        case .totalDistance: return \.totalDistance
        case .totalEnergy: return \.totalEnergy
        case .avgHeartRate: return \.avgHeartRate
        case .avgSpeed: return \.avgSpeed
        }
    }
    
    var color: Color {
        switch self {
        case .totalTime: return .green
        case .totalDistance: return .blue
        case .totalEnergy: return .orange
        case .avgHeartRate: return .red
        case .avgSpeed: return .yellow
        }
    }
}

@Model
class RunData: Identifiable {
    var date: Date
    var totalTime: Double
    var totalDistance: Double
    var totalEnergy: Double
    var avgHeartRate: Double
    var avgSpeed: Double
    
    init(date: Date, totalTime: Double, totalDistance: Double, totalEnergy: Double, avgHeartRate: Double, avgSpeed: Double) {
        self.date = date
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.avgSpeed = avgSpeed
    }
}
