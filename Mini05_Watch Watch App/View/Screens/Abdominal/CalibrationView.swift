//
//  CalibrationView.swift
//  Mini05_Watch Watch App
//
//  Created by Samu Lima on 06/06/24.
//

import SwiftUI
import SwiftData

struct CalibrationView: View {
    
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
                AC.startGyroscope()
            }
            .onDisappear {
                AC.stopGyroscope()
            }
    }
}

#Preview {
    CalibrationView()
}
