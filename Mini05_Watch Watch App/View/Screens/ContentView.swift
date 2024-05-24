//
//  ContentView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @StateObject private var healthManager: HeathKitManager = HeathKitManager()
    @State private var isAuthorized: HKAuthorizationStatus = .notDetermined
    
    var body: some View {
        verifyAutorization()
    }
}

extension ContentView{
    @ViewBuilder
    private func verifyAutorization() -> some View{
        if isAuthorized == .sharingAuthorized{
            HomeView()
        }else if isAuthorized == .sharingDenied{
            VStack{
               Text("Permissao negada")
                //colocar tutorial de  ir as configuraos aceitar a permisao
            }
        }else{
            RequestPermissionView(healthKitManager: self.healthManager,
                                        isAuthorized: self.$isAuthorized)
        }
    }
}

#Preview {
    ContentView()
}

