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
        VStack(alignment: .leading){
            labelOrText()
                .font(.system(size: 15))
            
            addHeart()
                .font(.system(size: 30, weight: .semibold))
        }.padding(.horizontal)

    }
}

extension SectionExercise{
    @ViewBuilder
    private func labelOrText() -> some View{
        if model.withSimbol && model.systemImage != "heart.fill"{
            Label(model.nameSection, systemImage: model.systemImage)
        }else{
            Text(model.nameSection)
        }
    }
    
    @ViewBuilder
    private func addHeart() -> some View{
        if model.systemImage == "heart.fill"{
            Label("\(formattedValue()) \(model.exetensionSection)", systemImage: "heart.fill")
        }else {
            Text("\(formattedValue()) \(model.exetensionSection)")
        }
    }
    
    private func formattedValue() -> String {
        return String(format: "%.2f", model.value)
    }
}


#Preview {
    SectionExercise(model: SectionExerciseModel(
                    exetensionSection: "cal",
                    systemImage: "flame.fill",
                    nameSection: "Calorias",
                    value: 1.0,
                    withSimbol: true
                ))
}
