//
//  ContentView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject private var hkManager: HeathKitManager
    @State private var authorizationStatuses: [HKObjectType: HKAuthorizationStatus] = [:]
    
    var body: some View {
        HomeView()
            .onAppear{
                print("Entes de permisao ")
                Task{
                    await hkManager.requestPermission()
                }
                print("depois  ")
            }
//        verifyAutorization()
//
//            .onAppear{
//                authorizationStatuses = healthManager.verifyStatusPermission()
//            }
    }
}

extension ContentView{
    @ViewBuilder
    private func verifyAutorization() -> some View{
        if allPermissionsAuthorized(){
            HomeView()
        }else if anyPermissionDenied(){
            VStack{
               Text("Permissao negada")
                //colocar tutorial de  ir as configuraos aceitar a permisao
            }
        }else{
            RequestPermissionView(healthKitManager: self.hkManager,
                                        authorizationStatuses: self.$authorizationStatuses)
        }
    }
    
    private func allPermissionsAuthorized() -> Bool{
        return !authorizationStatuses.values.contains(.notDetermined) &&
               !authorizationStatuses.values.contains(.sharingDenied)
    }
    
    private func anyPermissionDenied() -> Bool {
        return authorizationStatuses.values.contains(.sharingDenied)
    }
}

#Preview {
    ContentView()
}

