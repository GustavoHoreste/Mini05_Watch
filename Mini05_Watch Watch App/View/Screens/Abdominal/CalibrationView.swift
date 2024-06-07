//
//  CalibrationView.swift
//  Mini05_Watch Watch App
//
//  Created by Samu Lima on 06/06/24.
//

import SwiftUI
import SwiftData

struct CalibrationView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var abdominais:[AbdominalConfigData]
    private var abdominal: AbdominalConfigData? {
        abdominais.first
    }
    
    @State var gravou:Int = 0
    
    var AC:AbdominalConfig = AbdominalConfig()
    
    var body: some View {
        VStack{
            
            if gravou == 0 {
                Text("Fique em posição para")
                    
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                Text("a abdominal")
                    .font(.footnote)
                Text("Assim que vibrar, complete a abdominal")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                Text("E espere vibrar novamente")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                
                
            }
            
            if abdominal?.pontoBaixo == nil {
                Text("\(AC.rotationX.rounded(toPlaces: 2))")
            }
            
            else if abdominal?.pontoAlto == nil {
                Text("\(abdominal?.pontoBaixo?.rounded(toPlaces: 2))")
                Text("\(AC.rotationX.rounded(toPlaces: 2))")
            }
            
            else {
                Text("\(abdominal?.pontoBaixo?.rounded(toPlaces: 2))")
                Text("\(abdominal?.pontoAlto?.rounded(toPlaces: 2))")
            }
            
            Button {
                if AC.isRecording {
                    AC.isRecording = false
                } else {
                    AC.startRecording()
                }
                gravou += 1
            } label: {
                Text(AC.isRecording ? "Calibrando..." : "Começar calibragem")
            }
            
        }
        
        
            .onAppear {
                if abdominal == nil {
                    let newItem = AbdominalConfigData(pontoBaixo: nil, pontoAlto: nil)
                    modelContext.insert(newItem)
                }
                
                AC.startGyroscope()
            }
    }
}

#Preview {
    CalibrationView()
}
