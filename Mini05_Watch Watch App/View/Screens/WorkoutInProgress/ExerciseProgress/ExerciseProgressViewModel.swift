//
//  ExerciseProgressViewModel.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI
import CoreMotion

class ExerciseProgressViewModel: ObservableObject {
    @Published public var endWorkout: Bool = false
    @Published public var abdomemTrincado: Double = 0
    @Published public var isBackToView: Bool = false
    @Published public var selectExercise: [WorkoutViewsEnun] = []
    @Published public var sixeSelectExercise: Int = 0
    @Published public var isDecrementingTimer: Bool = false
    @Published private(set) var totalDuration: TimeInterval = 0
    @Published public var timerValue: Date = Date() {
        didSet {
            self.convertDateToDouble(timerValue)
        }
    }
    @Published public var rotationX: Double = 0.0
    @Published public var pontoAlto: Double?
    @Published public var pontoBaixo: Double?
    @Published private var stationaryCounter = 0
    @Published private var ultimoPonto = ""
    @Published private var debugMessage = ""
    
    public var startDate: Date?
    
    private var lastRotationX: Double = 0.0
    private var isRecording = false
    private var motionManager = CMMotionManager()
    private var timer: Timer?
    
    public func nextExercise() {
        if !selectExercise.isEmpty {
            self.selectExercise.removeFirst()
        }
    }
    
    public func toggleValueEnd() {
        self.endWorkout.toggle()
    }
    
    public func reseatAll() {
        self.selectExercise = []
        self.endWorkout = false
        self.isBackToView = false
        self.startDate = nil
        // self.isDecrementingTimer = false
    }
    
    public func backToView() {
        self.isBackToView = true
    }
    
    private func convertDateToDouble(_ date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        guard let hour = components.hour, let minute = components.minute, let second = components.second else {
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
    
    public func returnNameExercise() -> String {
        guard let name = selectExercise.first else {
            return "nil"
        }
        return name.rawValue
    }
    
    // MARK: - Gyroscope and Haptics
    
    public func startRecording() {
        isRecording = true
        stationaryCounter = 0
        lastRotationX = rotationX
        pontoAlto = nil
        pontoBaixo = nil
        startGyroscope()
    }
    
    private func startGyroscope() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                if let error = error {
                    self.debugMessage = "Erro ao acessar giroscópio: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else { return }
                
                self.rotationX = data.attitude.pitch.rounded(toPlaces: 2)
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                self.checkMotion()
            }
        } else {
            debugMessage = "Giroscópio não disponível"
        }
    }
    
    private func checkMotion() {
        if isRecording {
            // Check for stationary state
            if abs(rotationX - lastRotationX) < 0.02 {
                stationaryCounter += 1
            } else {
                stationaryCounter = 0
            }
            
            // If stationary for a period, record point
            if stationaryCounter >= 10 {
                stationaryCounter = 0
                if pontoBaixo == nil {
                    pontoBaixo = rotationX
                } else if pontoAlto == nil {
                    pontoAlto = rotationX
                    isRecording = false
                }
            }
            
            lastRotationX = rotationX
        }
        
        if let pontoBaixo = pontoBaixo, let pontoAlto = pontoAlto {
            if rotationX <= pontoBaixo && ultimoPonto == "" {
                ultimoPonto = "baixo"
            }
            
            if ultimoPonto == "baixo" && rotationX >= pontoAlto {
                ultimoPonto = "alto"
                abdomemTrincado += 1
            }
            
            if ultimoPonto == "alto" && rotationX <= pontoBaixo {
                ultimoPonto = "baixo"
                abdomemTrincado += 1
            }
        }
        
        debugMessage = ultimoPonto
    }
    
    
    public func stopGyroscope() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
