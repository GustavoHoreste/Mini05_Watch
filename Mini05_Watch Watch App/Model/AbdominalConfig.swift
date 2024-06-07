//
//  AbdominalConfig.swift
//  Mini05_Watch Watch App
//
//  Created by Felipe Porto on 07/06/24.
//

import Foundation
import CoreMotion
import SwiftUI
import SwiftData
import WatchKit

// Extension to round a Double to a specific number of decimal places
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// Model class for storing abdominal configuration data
@Model
class AbdominalConfigData: ObservableObject {
    var pontoBaixo: Double?
    var pontoAlto: Double?
    
    init(pontoBaixo: Double? = nil, pontoAlto: Double? = nil) {
        self.pontoBaixo = pontoBaixo
        self.pontoAlto = pontoAlto
    }
}

// Class for handling the gyroscope and recording logic
class AbdominalConfig:ObservableObject {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var abdominais:[AbdominalConfigData]
    private var abdominal: AbdominalConfigData? {
        abdominais.first
    }
    
    @Published var ultimoPonto: String = ""
    @Published var rotationX: Double = 0.0
    
    @Published var isRecording = false
    private var lastRotationX: Double = 0.0
    private var stationaryCounter = 0
    private var motionManager: CMMotionManager

    @Published var pontoBaixo: Double?
    @Published var pontoAlto: Double?

    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
    }
    
    func startGyroscope() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            self.rotationX = data.attitude.pitch.rounded(toPlaces: 2)
            self.updateRotation()
        }
    }
    
    func stopGyroscope() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func startRecording() {
        isRecording = true
        stationaryCounter = 0
        lastRotationX = rotationX
        pontoAlto = nil
        pontoBaixo = nil
    }
    
    private func updateRotation() {
        guard isRecording else { return }
        
        // Check for stationary state
        if abs(rotationX - lastRotationX) < 0.02 {
            stationaryCounter += 1
        } else {
            stationaryCounter = 0
        }
        
        // If stationary for a period, record point
        if stationaryCounter >= 20 {
            stationaryCounter = 0
            if pontoBaixo == nil {
                setPontoBaixo(rotationX)
                triggerHapticFeedback()
            } else if pontoAlto == nil {
                setPontoAlto(rotationX)
                triggerHapticFeedback()
                isRecording = false
            }
        }
        
        lastRotationX = rotationX
    }
    
    func setPontoAlto(_ rotation: Double) {
        abdominal?.pontoAlto = rotation
    }
    
    func setPontoBaixo(_ rotation: Double) {
        abdominal?.pontoBaixo = rotation
    }
    
    private func triggerHapticFeedback() {
            WKInterfaceDevice.current().play(.success)
        }
}

