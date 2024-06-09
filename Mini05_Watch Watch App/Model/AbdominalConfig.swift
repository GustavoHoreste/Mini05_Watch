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
    var pontoBaixo: Double
    var pontoAlto: Double
    
    init(pontoBaixo: Double, pontoAlto: Double) {
        self.pontoBaixo = pontoBaixo
        self.pontoAlto = pontoAlto
    }
}

// Class for handling the gyroscope and recording logic
class AbdominalConfig:ObservableObject {
    
    @Published var ultimoPonto: String = ""
    @Published var rotationX: Double = 0.0
    
    @Published var isRecording = false
    private var lastRotationX: Double = 0.0
    private var stationaryCounter = 0
    private var motionManager: CMMotionManager

    @Published var pontoBaixo: Double = 0
    @Published var pontoAlto: Double = 0
    
    @AppStorage("pontoBaixo") var ptBaixo: Double = 0
    @AppStorage("pontoAlto") var ptAlto: Double = 0

    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
    }
    
    func startGyroscope() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            print(ptAlto, ptBaixo, rotationX)
            
            self.rotationX = data.attitude.pitch.rounded(toPlaces: 2)
            self.updateRotation()
        }
    }
    
    func stopGyroscope() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func startRecording() {
        
        ptAlto = 0
        ptBaixo = 0
        
        isRecording = true
        stationaryCounter = 0
        lastRotationX = rotationX
        pontoAlto = 0
        pontoBaixo = 0
    }
    
    private func updateRotation() {
        guard isRecording else { return }
        
        // Check for stationary sstate
        if abs(rotationX - lastRotationX) < 0.02 {
            stationaryCounter += 1
        } else {
            stationaryCounter = 0
        }
        
        // If stationary for a period, record point
        if stationaryCounter >= 20 {
            stationaryCounter = 0
            if pontoBaixo == 0 {
                setPontoBaixo(rotationX)
                triggerHapticFeedback()
            } else if pontoAlto == 0 {
                setPontoAlto(rotationX)
                triggerHapticFeedback()
                isRecording = false
                stopGyroscope()
                
                print("Calibrou")
                
            }
        }
        
        if pontoAlto != 0 && pontoBaixo != 0 {
            ptAlto = pontoAlto
            ptBaixo = pontoBaixo
        }
        
        lastRotationX = rotationX
    }
    
    func setPontoAlto(_ rotation: Double) {
        pontoAlto = rotation
    }
    
    func setPontoBaixo(_ rotation: Double) {
        pontoBaixo = rotation
    }
    
    private func triggerHapticFeedback() {
            WKInterfaceDevice.current().play(.success)
        }
}

