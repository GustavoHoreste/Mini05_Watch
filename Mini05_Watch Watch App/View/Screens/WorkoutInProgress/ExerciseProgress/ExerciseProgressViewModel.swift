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
    @Published public var toSummaryViewAfterTime: Bool = false
    @Published public var allselectExercise: [WorkoutViewsEnun] = []
    @Published public var callSumaryView: Bool = false
    @Published public var isDecrementingTimer: Bool = false
    @Published public var totalDuration: TimeInterval?
    @Published public var timerValue: Date = Date(){
        didSet{
            self.convertDateToDouble(timerValue)
        }
    }
    @Published public var selectExercise: [WorkoutViewsEnun] = []

    public var startDate: Date?

    public func nextExercise(){
        if !selectExercise.isEmpty{
            self.selectExercise.removeFirst()
        }
    }
    
    public func toggleValueEnd(){
        DispatchQueue.main.async {
            self.endWorkout.toggle()
        }
    }
    
    private func callSumarryView(_ value: Double){
        if value == 0{
            self.toggleValueEnd()
        }
    }
    
    public func reseatAll(){
        self.selectExercise = []
        self.endWorkout = false
        self.isBackToView = false
        self.startDate = nil
        self.toSummaryViewAfterTime = false
        self.callSumaryView = false
//        self.isDecrementingTimer = false
        
        print("reseatado variavies do exercicio vm")
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
        guard let totalDuration = self.totalDuration else {return 1}
        
        guard let startDate = startDate else {
            return 1
        }
        let elapsedTime = date.timeIntervalSince(startDate)
        let timer = max(totalDuration - elapsedTime, 0)
        
        self.callSumarryView(timer)
        
        return timer
    }
    
    public func returnNameExercise() -> String{
        guard let name = selectExercise.first else {
            return "nil"
        }
        return name.rawValue
    }
}
