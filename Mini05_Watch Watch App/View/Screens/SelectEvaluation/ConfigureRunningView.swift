//
//  ConfigureRunningView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 01/06/24.
//

import SwiftUI

struct ConfigureRunningView: View {
    @State private var isSelectTime: Bool = false
    @State private var isNotSelectTime: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 10){
                Text("Corrida")
                    .font(.system(size: 21.5, weight: .medium))
                
                SelectBoxConponent(isSelect: $isSelectTime, nameButtom: "Tempo\nEstabelecido"){
                    self.isNotSelectTime = false
                }
                SelectBoxConponent(isSelect: $isNotSelectTime, nameButtom: "Tempo livre"){
                    self.isSelectTime = false
                }
                
                HStack{
                    Spacer()
                    NavigationLink{ self.verifyNextView() }label: {
                        ButtonNextLabel()
                    }
                    .disabled(!isSelectTime && !isNotSelectTime)
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .onAppear{
                self.isSelectTime = false
                self.isNotSelectTime = false
            }
        }
    }
}

//View builder
extension ConfigureRunningView{
    @ViewBuilder
    private func verifyNextView() -> some View{
        if isNotSelectTime{
            TabViewWorkout()//chamar cronometro view
        }else if isSelectTime{
            PickerTimerView()
        }
    }
}


#Preview {
    ConfigureRunningView()
        .environmentObject(ExerciseProgressViewModel())
}