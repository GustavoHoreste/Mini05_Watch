//
//  ButtonStatusComponent.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ButtonStatusComponent: View {
    let symbol: [String]
    let nameButton: [String]
    let action: () -> Void
    let isPauseOrPlay: Bool
    
    @State var buttonChange: Bool = false
    
    var body: some View {
        VStack{
            Button{
                verifiStatusButton()
            }label: {
                Image(systemName: buttonChange ? symbol[1] : symbol[0])
                    
            }.frame(width: 90, height: 50)
                
            Text(buttonChange ? nameButton[1] : nameButton[0])
                .font(.footnote)
        }
    }
}


extension ButtonStatusComponent{
    //TODO: - Verifica se e butao e de play e pause, se for, a logica de mudar label e ativada.
    private func verifiStatusButton(){
        if isPauseOrPlay{
            buttonChange.toggle()
            self.action()
            return
        }
        self.action()
    }
}

#Preview {
    ButtonStatusComponent(symbol: ["pause.fill", "play.fill"],
                          nameButton: ["Pause", "Play"],
                          action: {print("ola mundo")},
                          isPauseOrPlay: true)
}

