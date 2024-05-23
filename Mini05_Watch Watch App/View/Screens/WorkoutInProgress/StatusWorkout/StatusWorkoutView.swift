//
//  StatusWorkoutView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct StatusWorkoutView: View {
    var body: some View {
        NavigationStack{
            VStack {
                HStack(spacing: 10) {
                    ButtonStatusComponent(symbol: ["pause.fill", "play.fill"],
                                          nameButton: ["Pause", "Play"],
                                          action:  {print("play")},
                                          isPauseOrPlay: true)
                    
                    ButtonStatusComponent(symbol: ["xmark"],
                                          nameButton: ["Sair"],
                                          action:  {print("Sair")},
                                          isPauseOrPlay: false)
                }
                
                HStack{
                    Spacer()
                    ButtonStatusComponent(symbol: ["arrowshape.turn.up.right.fill"],
                                          nameButton: ["Próximo"],
                                          action:  {print("Próximo")},
                                          isPauseOrPlay: false)
                }.padding(.top)
            }.ignoresSafeArea()
                .navigationTitle("Status")
        }
    }
}



#Preview {
    StatusWorkoutView()
}


