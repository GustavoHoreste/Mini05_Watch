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
            Text("Cronômetro")
                .font(.callout)
            
            Text("Tempo de exercicio")
            Text("0:05:03")
                .font(.system(size: 25))
            
            HStack{
                Text("Tempo de avaliação")
                    .font(.system(size: 10))

                Text("0:05:03")
            }
            
            Divider()
            Label("Calorias", systemImage: "flame.fill")
            
            Text("130 kal")
                .font(.system(size: 25))
            
            Divider()
            
            Text("Ferequência cadiaca")
            Label("120 bpm", systemImage: "heart.fill")
                .font(.system(size: 25))
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
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ExerciseProgressView()
}

