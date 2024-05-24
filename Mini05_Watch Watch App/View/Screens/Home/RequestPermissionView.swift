//
//  PermissionRequestDeniedView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 24/05/24.
//

import SwiftUI
import HealthKit

struct RequestPermissionView: View {
    @ObservedObject var healthKitManager: HeathKitManager
    @Binding var isAuthorized: HKAuthorizationStatus
    
    var body: some View {
        VStack{
            Label("Aceite a permisao", systemImage: "person.fill.checkmark")
            
            Button{
                Task{
                    isAuthorized = await healthKitManager.requestPermission()
                }
            }label: {
                Text("Pedir")
            }
        }
    }
}

#Preview {
    RequestPermissionView(healthKitManager: HeathKitManager(),
                                isAuthorized:.constant(HKAuthorizationStatus.notDetermined))
}

