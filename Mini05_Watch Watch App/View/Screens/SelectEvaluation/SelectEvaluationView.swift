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
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0)
                        SelectionBox(selectedExercises: $exerciseViewModel.selectExercise, exerciseName: .complete, allExercises: exercises, isCompleteButton: true)
                            .foregroundStyle(.black)
                            .buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding(.horizontal, 5)
                    Divider()
                    Spacer()
                    HStack{
                    }
                    
                    ForEach(exercises, id: \.self) { exercise in
                        ZStack{
                            RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                                .foregroundStyle(.myBlack)
                            SelectionBox(selectedExercises: $exerciseViewModel.selectExercise, exerciseName: exercise, allExercises: exercises, isCompleteButton: false)
                                .buttonStyle(PlainButtonStyle())
                            
                        }
                        .padding(.horizontal, 5)
                    }
                
                    
                    NavigationLink {
                        self.configRinning()
                    } label: {
                        ButtonNextLabel()
                    }
                    .disabled(exerciseViewModel.selectExercise.isEmpty)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.leading, 80)
                    .padding(.top, 5)
                    
            }
            .background(.bg)
            .myBackButton()
            
        }
    }
}

extension SelectEvaluationView{
    @ViewBuilder
    private func configRinning() -> some View{ ///Verifica se corrida foi escolhida, se for chama a view de configura corrida. 
        if exerciseViewModel.selectExercise.contains(.running12min){
            withAnimation {
                ConfigureRunningView()
            }
        }else{
            withAnimation {
                TimerAnimation(destination: TabViewWorkout())
                    .background(.bg)
            }
        }
    }
}

#Preview {
    SelectEvaluationView()
        .environmentObject(ExerciseProgressViewModel())
}

