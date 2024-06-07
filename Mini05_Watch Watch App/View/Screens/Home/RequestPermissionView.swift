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
    @State private var heartScale: CGFloat = 1.0
    
    var body: some View {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color("myOrange"))
                        .scaleEffect(heartScale)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: heartScale)
                        .onAppear {
                            heartScale = 1.2
                        }
                    
                    Text("Autorize o Acesso")
                        .myCustonFont(fontName: .sairaMedium, size: 15, valueScaleFactor: 0.8)
                }

                
                Button {
                    isShowingLoadingSheet = true
                    Task {
                        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                        authorizationStatuses = await healthKitManager.requestPermission()
                        isShowingLoadingSheet = false
                    }
                } label: {
                    HStack {
                        Text("Requisitar")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .padding()
                    .background(Color(.nextButton))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }.buttonStyle(.plain)
                Spacer()
                
                
                HStack(spacing: 10){
                    Image(systemName: "questionmark.circle.fill")
                    Text("Precisamos da sua permissão para acessar os dados do HealthKit")
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .myCustonFont(fontName: .sairaRegular, size: 10, valueScaleFactor: 0.8)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea())
        .sheet(isPresented: $isShowingLoadingSheet) {
            LoadingView()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Carregando permissão...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
                .toolbar(.hidden, for: .navigationBar)
                .background(Color("bg").opacity(0.5))
        }
    }
}

#Preview {
    RequestPermissionView(
        healthKitManager: HealthKitManager(),
        authorizationStatuses: .constant([:])
    )
}

