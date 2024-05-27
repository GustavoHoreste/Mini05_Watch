//
//  RunData.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 24/05/24.
//

import Foundation
import SwiftData

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
}

@Model
class RunData: Identifiable {
    var date: Date
    var totalTime: TimeInterval
    var totalDistance: Double
    var totalEnergy: Double
    var avgHeartRate: Double
    var avgSpeed: Double
    
    init(date: Date, totalTime: TimeInterval, totalDistance: Double, totalEnergy: Double, avgHeartRate: Double, avgSpeed: Double) {
        self.date = date
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.avgSpeed = avgSpeed
    }
}
