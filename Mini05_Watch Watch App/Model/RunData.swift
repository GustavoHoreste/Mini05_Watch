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
    case totalEnergy
    case avgHeartRate
    case avgSpeed
    
    var id: String {
        switch self {
        case .totalEnergy: return "Total Energy"
        case .avgHeartRate: return "Avg Heart Rate"
        case .avgSpeed: return "Avg Speed"
        }
    }
    
    var keyPath: KeyPath<RunData, Double> {
        switch self {
        case .totalEnergy: return \.totalEnergy
        case .avgHeartRate: return \.avgHeartRate
        case .avgSpeed: return \.avgSpeed
        }
    }
    
    var color: Color {
        switch self {
        case .totalEnergy: return .orange
        case .avgHeartRate: return .red
        case .avgSpeed: return .yellow
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .totalEnergy: return "flame.fill"
        case .avgHeartRate: return "heart.fill"
        case .avgSpeed: return "figure.run"
        }
    }
}

@Model
class RunData: Identifiable {
    var date: Date
    var totalEnergy: Double
    var avgHeartRate: Double
    var avgSpeed: Double
    
    init(date: Date, totalEnergy: Double, avgHeartRate: Double, avgSpeed: Double) {
        self.date = date
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.avgSpeed = avgSpeed
    }
}
