//
//  SummaryViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 06/06/24.
//

import Foundation
import SwiftUI

class SummaryViewModel: ObservableObject {
    @AppStorage("recordTempoRun") var recordTempoRun = 0
    @AppStorage("recordTempoPushUp") var recordTempoPushUp = 0
    @AppStorage("recordTempoAbdominal") var recordTempoAbdominal = 0
    @AppStorage("recordSpeedRun") var recordSpeedRun = 0
    @AppStorage("recordRepsPushUp") var recordRepsPushUp = 0
    @AppStorage("recordRepsAbdominal") var recordRepsAbdominal = 0
    
    func tempoRecord(enun: WorkoutViewsEnun, value: Double)-> String {
        switch enun {
        case .running12min:
            if recordTempoRun == 0 || Int(value) < recordTempoRun {
                recordTempoRun = Int(value)
                return Int(value).formatTime()
            }
        case .pushUps:
            if recordTempoPushUp == 0 || Int(value) < recordTempoPushUp {
                recordTempoPushUp = Int(value)
                return Int(value).formatTime()
            }
        default:
            if recordTempoAbdominal == 0 || Int(value) < recordTempoAbdominal {
                recordTempoAbdominal = Int(value)
                return Int(value).formatTime()
            }
        }
        return ""
    }
    
    func speedOrRepRecord(enun: WorkoutViewsEnun, value: Double)-> String {
        switch enun {
        case .running12min:
            if recordSpeedRun == 0 || Int(value) < recordSpeedRun {
                recordSpeedRun = Int(value)
                return "\(Int(value))Km/h"
            }
        case .pushUps:
            if recordRepsPushUp == 0 || Int(value) < recordRepsPushUp {
                recordRepsPushUp = Int(value)
                return "\(Int(value))"
            }
        default:
            if recordRepsAbdominal == 0 || Int(value) < recordRepsAbdominal {
                recordRepsAbdominal = Int(value)
                return "\(Int(value))"
            }
        }
        return ""
    }
    
}

extension Int {
    func formatTime()-> String {
        let minutes = self / 60
        let remainingSeconds = self % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
