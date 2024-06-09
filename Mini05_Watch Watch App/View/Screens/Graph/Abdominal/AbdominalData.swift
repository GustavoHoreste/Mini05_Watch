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
    case totalEnergy
    case avgHeartRate
    case repetitions
    
    var id: String {
        switch self {
        case .totalEnergy: return "Calorias Totais"
        case .avgHeartRate: return "Frequência cardíaca média"
        case .repetitions: return "Repetições"
        }
    }
    
    var keyPath: KeyPath<AbdominalData, Double> {
        switch self {
        case .totalEnergy: return \.totalEnergy
        case .avgHeartRate: return \.avgHeartRate
        case .repetitions: return \.repetitions
        }
    }
    
    var color: Color {
        switch self {
        case .totalEnergy: return .orange
        case .avgHeartRate: return .red
        case .repetitions: return .yellow
        }
    }
    
    var sfSymbol: String {
        switch self {
        case .totalEnergy: return "flame.fill"
        case .avgHeartRate: return "heart.fill"
        case .repetitions: return "figure.core.training"
        }
    }
}

@Model
class AbdominalData: Identifiable {
    var date: Date
    var totalEnergy: Double
    var avgHeartRate: Double
    var repetitions: Double
    
    init(date: Date, totalEnergy: Double, avgHeartRate: Double, repetitions: Double) {
        self.date = date
        self.totalEnergy = totalEnergy
        self.avgHeartRate = avgHeartRate
        self.repetitions = repetitions
    }
}
