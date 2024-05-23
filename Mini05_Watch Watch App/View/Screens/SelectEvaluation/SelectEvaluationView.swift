//
//  SelectEvaluation.swift
//  Mini05 Watch App
//
//  Created by Samu Lima on 21/05/24.
//

import SwiftUI

struct SelectEvaluationView: View {
    @State private var selectedExercises: [String] = []
    @State private var exercises: [String] = ["Flexão", "Abdominal", "Corrida"]
    
    var body: some View {
        
        NavigationStack {
                ScrollView {
                    SelectionBox(selectedExercises: $selectedExercises, exerciseName: "Completa", allExercises: exercises, isCompleteButton: true)
                    
                    Divider()
                    
                    HStack{
                        Text("Exercícios")
                        Spacer()
                    }
                    
                    ForEach(exercises, id: \.self) { exercise in
                        SelectionBox(selectedExercises: $selectedExercises, exerciseName: exercise, allExercises: exercises, isCompleteButton: false)
                    }
                
                    Divider()
                    
                    NavigationLink("NextView") {
                        TabViewWorkout()
                    }
                    
            }
        }
    }
}

#Preview {
    SelectEvaluationView()
}

