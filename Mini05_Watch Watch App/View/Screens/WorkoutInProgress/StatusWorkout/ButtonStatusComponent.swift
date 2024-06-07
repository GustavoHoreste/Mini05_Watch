//
//  ButtonStatusComponent.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ButtonStatusComponent: View {
    @EnvironmentObject private var healthManager: HealthKitManager

    let symbol: [ImageResource]
    let nameButton: [String]
    let action: () -> Void
//    let isPauseOrPlay: Bool
    
    @State var buttonChange: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: -3){
            Button{
                verifiStatusButton()
            }label: {
                Image(buttonChange ? symbol[1] : symbol[0])
                    .frame(width: DeviceScreen.getDimension(proportion: 0.45, forWidth: true),
                            height: DeviceScreen.getDimension(proportion: 0.35, forWidth: true))
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 9)
            )
            
            Text(buttonChange ? nameButton[1] : nameButton[0])
                .myCustonFont(fontName: .sairaMedium, size: 14, valueScaleFactor: 0.8)
        }
    }
}


extension ButtonStatusComponent{
    //TODO: - Verifica se e butao e de play e pause, se for, a logica de mudar label e ativada.
    private func verifiStatusButton(){
        if nameButton.first == "Pause"{
            buttonChange.toggle()
            self.action()
            return
        }
        self.action()
    }
}

#Preview {
    ButtonStatusComponent(symbol: [.pauseSimbolo, .despauseSimbolo],
                          nameButton: ["Pause", "Play"],
                          action: {print("ola mundo")})
}

