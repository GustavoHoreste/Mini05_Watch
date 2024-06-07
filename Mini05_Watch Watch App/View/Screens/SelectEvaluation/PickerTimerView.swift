//
//  PickerTimerView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 01/06/24.
//

import SwiftUI

struct PickerTimerView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @State private var selectedMinutesIndex: Int = 0
    @State private var selectedHourIndex: Int = 0
    @State private var selectedSecondIndex: Int = 5

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                
                Text("Tempo\nEstabelecido")
                    .lineLimit(2)
                    .myCustonFont(fontName: .sairaMedium, size: 20, valueScaleFactor: 0.8)
        
                HStack {
                    Picker("Horas", selection: $selectedHourIndex) {
                        ForEach(00..<24) { hour in
                            Text("\(hour)")
                                .myCustonFont(fontName: .sairaBold, size: 15, valueScaleFactor: 0.8)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: DeviceScreen.getDimension(proportion: 0.27, forWidth: true))
                    
                    Picker("Min", selection: $selectedMinutesIndex) {
                        ForEach(00..<60) { minute in
                            Text("\(minute)")
                                .myCustonFont(fontName: .sairaBold, size: 15, valueScaleFactor: 0.8)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: DeviceScreen.getDimension(proportion: 0.27, forWidth: true))

                    Picker("Seg", selection: $selectedSecondIndex) {
                        ForEach(00..<60) { second in
                            Text("\(second)")
                                .myCustonFont(fontName: .sairaBold, size: 15, valueScaleFactor: 0.8)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: DeviceScreen.getDimension(proportion: 0.27, forWidth: true))
                }

                HStack{
                    Spacer()
                    
                    NavigationLink {
                        withAnimation {
                            TimerAnimation(destination: TabViewWorkout())
                                .background(.bg)
                        }
                    } label: {
                        ButtonNextLabel()
                    }.buttonStyle(.plain)

                }
            }
            .onAppear{
                exerciseViewModel.isDecrementingTimer = true //define o a configuracao como timerDecrecente
            }
            .onDisappear{
                exerciseViewModel.timerValue = convertIntToDate()
                self.reasetData()
            }
            .background(.bg)
            .myBackButton()
        }.padding(.horizontal)
    }
}

extension PickerTimerView{
    private func convertIntToDate() -> Date{
        let currentDate = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(bySettingHour: selectedHourIndex, minute: selectedMinutesIndex, second: selectedSecondIndex, of: currentDate)!
        
        return newDate
    }
    
    private func reasetData(){
        selectedMinutesIndex = 12
        selectedHourIndex = 0
        selectedSecondIndex = 0
    }
}

#Preview {
    PickerTimerView()
        .environmentObject(ExerciseProgressViewModel())
}
