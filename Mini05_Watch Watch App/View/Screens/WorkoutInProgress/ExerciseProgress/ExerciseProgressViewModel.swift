//
//  ExerciseProgressViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI
import SwiftData
import CoreMotion

class ExerciseProgressViewModel: ObservableObject{
    
    public var healthManager: HealthKitManager?
    private let motionManager = CMMotionManager()
    private var rotationX:Double = 0
    private var ultimoPonto = ""
    
    
    @AppStorage("pontoBaixo") var ptBaixo: Double = 0
    @AppStorage("pontoAlto") var ptAlto: Double = 0
    
    @Published public var abdomenTrincado:Double = 0
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
    private var hasExecute: Bool = false
    
    public func nextExercise(){
        if !selectExercise.isEmpty{
            self.selectExercise.removeFirst()
        }
    }
    
    public func toggleValueEnd(){
        DispatchQueue.main.async {
            if !self.endWorkout{
                self.endWorkout = true
            }
        }
    }
    
    public func callSumarryView(){
        DispatchQueue.main.async {
            if self.selectExercise[1] == .summary{
                self.toggleValueEnd()
            }else if !self.callSumaryView{
                self.callSumaryView = true
            }
        }
    }
    
    public func reseatAll() {
        self.selectExercise = []
        self.endWorkout = false
        self.isBackToView = false
        self.startDate = nil
        self.toSummaryViewAfterTime = false
        self.callSumaryView = false
        self.isDecrementingTimer = false
        self.hasExecute = false
        self.totalDuration = nil
        self.timerValue = Date()
//        self.allselectExercise = []

        print("Resetei as variáveis do exercício view model")
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
        
        print(timer)
        
        return timer
    }
    
    public func returnNameExercise() -> String{
        guard let name = selectExercise.first else {
            return "nil"
        }
        return name.rawValue
    }
    
    public func startGyroscope() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2
            motionManager.startDeviceMotionUpdates(to: .main) { [self] (data, error) in
                
                guard let data = data else { return }
                
                print(ptAlto, ptBaixo, rotationX)
                
                rotationX = data.attitude.pitch.rounded(toPlaces: 2)
                
                if rotationX <= (ptBaixo + 0.18) && ultimoPonto == "" {
                            ultimoPonto = "baixo"
                        }
                        
                        if ultimoPonto == "baixo" && rotationX >= (ptAlto - 0.18) {
                            ultimoPonto = "alto"
                        }
                        
                        if ultimoPonto == "alto" && rotationX <= (ptBaixo + 0.18) {
                            ultimoPonto = "baixo"
                            abdomenTrincado += 1
                            
                            triggerHapticFeedback()
                            
                }
            }
        }
    }
    
    func stopGyroscope() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func triggerHapticFeedback() {
            WKInterfaceDevice.current().play(.success)
        }
}
