//
//  PermissionRequestDeniedView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 24/05/24.
//

import SwiftUI
import HealthKit


struct RequestPermissionView: View {
    @ObservedObject var healthKitManager: HealthKitManager
    @Binding var authorizationStatuses: [HKObjectType: HKAuthorizationStatus]
    @State private var isShowingLoadingSheet = false
    
    var body: some View {
        VStack {
            Label("Aceite a permissão", systemImage: "person.fill.checkmark")
            Button {
                isShowingLoadingSheet = true
                Task {
                    try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                    authorizationStatuses = await healthKitManager.requestPermission()
                    isShowingLoadingSheet = false
                }
            } label: {
                Text("Pedir")
            }
        }
        .sheet(isPresented: $isShowingLoadingSheet) {
            LoadingView()
        }
    }
}

#Preview {
    RequestPermissionView(
        healthKitManager: HealthKitManager(),
        authorizationStatuses: .constant([:])
    )
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Carregando permissão...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
                .toolbar(.hidden, for: .navigationBar)
                .background(.bg.opacity(0.5))
        }
    }
}

#Preview {
    RequestPermissionView(healthKitManager: HealthKitManager(), authorizationStatuses: .constant([:]))
}

