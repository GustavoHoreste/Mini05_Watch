//
//  ExerciseProgressViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI

class ExerciseProgressViewModel: ObservableObject{
    @Published public var endWorkout: Bool = false
    @Published public var isBackToView: Bool = false
    @Published public var selectExercise: [WorkoutViewsEnun] = []
    @Published public var sixeSelectExercise: Int = 0
    @Published public var isDecrementingTimer: Bool = false
    @Published private(set) var totalDuration: TimeInterval = 0
    @Published public var timerValue: Date = Date(){
        didSet{
            self.convertDateToDouble(timerValue)
        }
    }

    public var startDate: Date?

    public func nextExercise(){
        if !selectExercise.isEmpty{
            self.selectExercise.removeFirst()
        }
    }
    
    public func toggleValueEnd(){
        self.endWorkout.toggle()
    }
    
    public func reseatAll(){
        self.selectExercise = []
        self.endWorkout = false
        self.isBackToView = false
        self.startDate = nil
//        self.isDecrementingTimer = false
    }
    
    public func backToView(){
        self.isBackToView = true
    }
    
    private func convertDateToDouble(_ date: Date){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        guard let hour = components.hour, let minute = components.minute, let second = components.second else{
            return
        }
        
        let totalSeconds = Double(hour * 3600 + minute * 60 + second)
        
        self.totalDuration = totalSeconds
    }
    
    
    
    public func remainingTime(at date: Date) -> TimeInterval {
        guard let startDate = startDate else {
            return totalDuration
        }
        let elapsedTime = date.timeIntervalSince(startDate)
        return max(totalDuration - elapsedTime, 0)
    }
    
    public func returnNameExercise() -> String{
        guard let name = selectExercise.first else {
            return "nil"
        }
        return name.rawValue
    }
}
