//
//  PickerTimerView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 01/06/24.
//

import SwiftUI

struct PickerTimerView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("Tempo\nEstabelecido")
                    .lineLimit(2)
                
                DatePicker("Seleciona ai", selection: $exerciseViewModel.timerValue, displayedComponents: .hourMinuteAndSecond)
                    .datePickerStyle(.automatic)
                    
                
                HStack{
                    Spacer()
                    ButtonNext(destination: TabViewWorkout())
                }
            }
            .onAppear{
                exerciseViewModel.isDecrementingTimer = true //define o a configuracao como timerDecrecente
            }
        }.padding(.horizontal)
    }
}

#Preview {
    PickerTimerView()
        .environmentObject(ExerciseProgressViewModel())
}
