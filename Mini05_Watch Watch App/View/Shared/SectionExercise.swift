//
//  SectionExercise.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 23/05/24.
//

import SwiftUI

struct SectionExercise: View {
    let model: SectionExerciseModel
    
    var body: some View {
        HStack{
            Text("\(formattedValue())\(model.exetensionSection)")
                .myCustonFont(fontName: .sairaRegular, size: 21.5, valueScaleFactor: 0.8)
            
            Spacer()
            Image(systemName: model.systemImage)
                .myCustonFont(fontName: .sairaRegular, size: 21.5, valueScaleFactor: 0.8)
                .foregroundStyle(Color(.myOrange))
            
        }.padding(.horizontal)
    }
}

extension SectionExercise{
    private func formattedValue() -> String {
        return String(format: "%.0f", model.value)
    }
}


#Preview {
    SectionExercise(model: SectionExerciseModel(
                    exetensionSection: "bpm",
                    systemImage: "bolt.heart",
                    value: 123))
}
