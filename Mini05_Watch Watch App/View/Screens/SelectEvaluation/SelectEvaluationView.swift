//
//  SelectEvaluation.swift
//  Mini05 Watch App
//
//  Created by Samu Lima on 21/05/24.
//

import SwiftUI

struct SelectEvaluationView: View {
    @EnvironmentObject private var exerciseViewModel: ExerciseProgressViewModel
    @State private var exercises: [WorkoutViewsEnun] = [.pushUps, .abdominal, .running12min]
    
    var body: some View {
        
        NavigationStack {
                ScrollView {
                    SelectionBox(selectedExercises: $exerciseViewModel.selectExercise, exerciseName: .complete, allExercises: exercises, isCompleteButton: true)
                    
                    Divider()
                    
                    HStack{
                        Text("Exercícios")
                        Spacer()
                    }
                    
                    ForEach(exercises, id: \.self) { exercise in
                        SelectionBox(selectedExercises: $exerciseViewModel.selectExercise, exerciseName: exercise, allExercises: exercises, isCompleteButton: false)
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
        .environmentObject(HealthKitManager())
}

