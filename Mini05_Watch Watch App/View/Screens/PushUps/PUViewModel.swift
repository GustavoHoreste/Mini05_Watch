//
//  PUViewModel.swift
//  Mini05 Watch App
//
//  Created by Felipe Porto on 21/05/24.
//

import CoreMotion

class PUViewModel: ObservableObject {
    
    var model:PUModel = PUModel()
    let motionManager = CMMotionManager()
    
    func startRegister() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            
            motionManager.startDeviceMotionUpdates(to: .main) {
                (data, error) in
                
                guard let motionData = data else {return}
                
                let acceleration = motionData.userAcceleration
                let rotation = motionData.rotationRate
                
                self.pushUpRegister(acceleration, rotation)
                
            }
            
        }
    }
    
    func pushUpRegister(_ acceleration: CMAcceleration, _ rotation: CMRotationRate) {
        
        let accelerationThreshold = 0.5
        let rotationThreshold = 0.5
        
        if acceleration.x > accelerationThreshold && abs(rotation.x) > rotationThreshold {
            model.pushUps += 0.5
        } else if acceleration.x > -accelerationThreshold && abs(rotation.x) > rotationThreshold {
            model.pushUps += 0.5
        }
        
    }

}
