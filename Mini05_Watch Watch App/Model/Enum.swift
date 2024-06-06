//
//  Enum.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 23/05/24.
//

import Foundation


enum Tabs {
    case exercise, status, nowPlaying
}


enum WorkoutViewsEnun: String{
    case running12min = "Corrida", pushUps = "Flexão", abdominal = "Abdominal", complete = "Completa", summary = "Summary"
    
    var speedOrRep: String {
        switch self {
        case .running12min: return "Velocidade média"
        default: return "Repetições"
        }
    }
    
    var speedOrRepRecord: String {
        switch self {
        case .running12min: return "Velocidade Recorde"
        default: return "Repetições Recorde"
        }
    }
    
    var keyPath: KeyPath<HealthKitManager, Double>{
        switch self {
        case .running12min: return \.runningSpeed
        case .pushUps: return \.repetitions
        default: return \.repetitions
        }
    }
    
    var keyPathTimer: KeyPath<HealthKitManager, Double>{
        switch self {
        case .running12min: return \.timerFinishRun
        case .pushUps: return \.timerFinishPushUps
        default: return \.timerFinishAbdominal
        }
    }
    
}


enum Fonts: String{
    case sairaMedium = "Saira-Medium"
    case sairaBlack = "Saira-Black"
    case sairaBold = "Saira-Bold"
    case sairaRegular = "Saira-Regular"
}
