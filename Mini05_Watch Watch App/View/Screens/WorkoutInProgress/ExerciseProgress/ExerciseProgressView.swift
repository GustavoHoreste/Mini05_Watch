//
//  ExerciseProgressView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 22/05/24.
//

import SwiftUI

struct ExerciseProgressView: View {
    var body: some View {
        MakeExerciseProgressView {
            
            stopwatchElements()
                .padding(.leading)
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "cal",
                                systemImage: "flame.fill",
                                nameSection: "Calorias",
                                value: 130,
                                withSimbol: true))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "m/s",
                                systemImage: "bolt.fill",
                                nameSection: "Velocidade",
                                value: 23.5,
                                withSimbol: true))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "km",
                                systemImage: "map.fill",
                                nameSection: "Distância",
                                value: 0.5,
                                withSimbol: false))
            
            Divider()
            SectionExercise(model: SectionExerciseModel(
                                exetensionSection: "bpm",
                                systemImage: "heart.fill",
                                nameSection: "Frequência Cardíaca",
                                value: 120,
                                withSimbol: true))
        }
    }
}

extension ExerciseProgressView{
    @ViewBuilder
    private func stopwatchElements() -> some View{
        Text("Cronômetro")
            .font(.callout)
        
        VStack(alignment: .leading){
//            Text("Tempo de exercicio")
//                .font(.system(size: 13))
            Text("0:00:00")
                .font(.system(size: 30))
        }
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 2)
//                    
//            }
        
        HStack{
            Text("Tempo de avaliação")
                .font(.system(size: 10))
            
            Text("0:05:03")
        }.frame(width: 180, height: 30)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 2)
            }
    }
}

//intencao e criar view diferentes de acordo com o exercicio
struct MakeExerciseProgressView<T: View>: View {
    let content: T
    
    init(@ViewBuilder _ content: () -> T) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                    content
                }.navigationTitle("Defult")//mudar de acordo com o nome do exercicio
            }
        }
    }
}

#Preview {
    ExerciseProgressView()
}

