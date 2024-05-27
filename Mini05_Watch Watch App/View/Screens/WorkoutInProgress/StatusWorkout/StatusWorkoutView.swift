//
//  StatusWorkoutView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct StatusWorkoutView: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @State private var nextView: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    ButtonStatusComponent(symbol: ["pause.fill", "play.fill"],
                                          nameButton: ["Pause", "Play"],
                                          action:  {healthManager.togglePauseOrStart()},
                                          isPauseOrPlay: true)
                    
                    Spacer()
                    
                    ButtonStatusComponent(symbol: ["xmark"],
                                          nameButton: ["Sair"],
                                          action:  
                                            {
                                                healthManager.endSession()
                                                nextView = true
                                            },
                                          isPauseOrPlay: false)
                }
                
                HStack{
                    Spacer()
                    ButtonStatusComponent(symbol: ["arrowshape.turn.up.right.fill"],
                                          nameButton: ["Próximo"],
                                          action:  {print("Próximo")},
                                          isPauseOrPlay: false)
                }.padding(.top)
                
            }.padding(.top)
            .navigationTitle("Status")
                .navigationDestination(isPresented: $nextView) {
                    SummaryView()
                }
        }
    }
}



#Preview {
    StatusWorkoutView()
        .environmentObject(HealthKitManager())
}


