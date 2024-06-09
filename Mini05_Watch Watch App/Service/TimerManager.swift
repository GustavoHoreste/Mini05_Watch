//
//  TimerManager.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 26/05/24.
//

import Foundation

class TimeManager {
    var totalTime: TimeInterval = 0
    var exerciseTime: TimeInterval = 0
    private var startDate: Date?
    private var exerciseStartDate: Date?
    private var isPaused: Bool = false
    
    func start() {
        if !isPaused {
            startDate = Date()
            exerciseStartDate = Date()
        } else {
            let pausedTime = Date().timeIntervalSince(exerciseStartDate ?? Date())
            exerciseTime += pausedTime
            startDate = Date()
        }
        isPaused = false
    }
    
    func pause() {
        guard let startDate = startDate else { return }
        let pausedTime = Date().timeIntervalSince(startDate)
        totalTime += pausedTime
        isPaused = true
        exerciseStartDate = nil
    }
    
    func reset() {
        totalTime = 0
        exerciseTime = 0
        startDate = nil
        exerciseStartDate = nil
        isPaused = false
    }
    
    func updateElapsedTime() {
        guard let startDate = startDate else { return }
        let currentTime = Date().timeIntervalSince(startDate)
        totalTime = currentTime + (isPaused ? 0 : exerciseTime)
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let subseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
        return String(format: "%02d:%02d:%02d", minutes, seconds, subseconds)
    }
}
