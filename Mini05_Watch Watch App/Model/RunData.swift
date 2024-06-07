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
    case totalDistance
    
    var id: String {
        switch self {
        case .totalEnergy: return "Calorias Totais"
        case .avgHeartRate: return "Frequência cardíaca média"
        case .avgSpeed: return "Velocidade média"
        case .totalDistance: return "Distância percorrida"
        }
    }
    
    var keyPath: KeyPath<RunData, Double> {
        switch self {
        case .totalEnergy: return \.totalEnergy
        case .avgHeartRate: return \.avgHeartRate
        case .avgSpeed: return \.avgSpeed
        case .totalDistance: return \.totalDistance
        }
    }
    
    var color: Color {
        switch self {
        case .totalEnergy: return .orange
        case .avgHeartRate: return .red
        case .avgSpeed: return .yellow
        case .totalDistance: return .blue
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .totalEnergy: return "flame.fill"
        case .avgHeartRate: return "heart.fill"
        case .avgSpeed: return "figure.run"
        case .totalDistance: return "figure.run"
        }
    }
}

@Model
class RunData: Identifiable {
    var date: Date
    var totalEnergy: Double
    var avgHeartRate: Double
    var avgSpeed: Double
    var totalDistance: Double
    
    init(date: Date, totalEnergy: Double, avgHeartRate: Double, avgSpeed: Double, totalDistance: Double) {
        self.date = date
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.avgSpeed = avgSpeed
        self.totalDistance = totalDistance
    }
}
