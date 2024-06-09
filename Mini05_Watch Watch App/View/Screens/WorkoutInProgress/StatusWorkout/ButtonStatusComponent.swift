//
//  ButtonStatusComponent.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

//  ButtonStatusComponent.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ButtonStatusComponent: View {
    @EnvironmentObject private var healthManager: HealthKitManager
    @State private var buttonChange: Bool = false

    let symbols: [ImageResource]
    let nameButton: [String]
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: -3) {
            Button {
                self.action()
            } label: {
                self.returnLabel()
                    .frame(width: DeviceScreen.getDimension(proportion: 0.45, forWidth: true),
                           height: DeviceScreen.getDimension(proportion: 0.35, forWidth: true))
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .foregroundStyle(Color("myWhite"))
            )
            
            Text(healthManager.session?.state == .paused ? nameButton[1] : nameButton[0])
                .myCustonFont(fontName: .sairaMedium, size: 14, valueScaleFactor: 0.8)
        }
    }
}

extension ButtonStatusComponent {
    @ViewBuilder
    private func returnLabel() -> some View {
        if nameButton.contains("Pausar") {
            switch healthManager.session?.state {
            case .paused:
                Image(symbols[1])
            default:
                Image(symbols[0])
            }
        } else {
            Image(symbols[0])
        }
    }
}

#Preview {
    ButtonStatusComponent(symbols: [.pauseSimbolo, .despauseSimbolo],
                          nameButton: ["Pausar", "Retomar"],
                          action: { print("ola mundo") })
        .environmentObject(HealthKitManager())
}
