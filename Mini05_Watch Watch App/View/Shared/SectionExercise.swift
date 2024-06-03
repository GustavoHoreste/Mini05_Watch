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
                .font(.system(size: 21.5))
            
            Spacer()
            
            Image(systemName: model.systemImage)
                .font(.system(size: 21.5))
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
