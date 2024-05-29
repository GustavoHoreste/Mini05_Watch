//
//  SelectionBox.swift
//  Mini05 Watch App
//
//  Created by Samu Lima on 21/05/24.
//

import SwiftUI

struct SelectionBox: View {
    @State private var checkState: Bool = false
    @Binding var selectedExercises: [WorkoutViewsEnun]
    let exerciseName: WorkoutViewsEnun
    var allExercises: [WorkoutViewsEnun]
    var isCompleteButton: Bool
    
    var body: some View {
        
        Button{
            self.checkState.toggle()
            // caso o usuário escolha a opção "completa" tds os exercicios serao adicionados na array
            if self.isCompleteButton {
                if self.checkState {
                    self.selectedExercises = self.allExercises
                    self.selectedExercises.append(.summary)
                } else {
                    self.selectedExercises.removeAll()
                }
                // caso contrário ele vai seguir numerando os outros checkboxes e adicionando os exercicios especificos na array
            } else {
                if self.checkState {
                    self.selectedExercises.append(self.exerciseName)
                    self.selectedExercises.append(.summary)
                } else {
                    if let index = self.selectedExercises.firstIndex(of: self.exerciseName) {
                        self.selectedExercises.remove(at: index)
                    }
                }
            }
            
            print("Selected Exercises: \(self.selectedExercises)")
            
        }label: {
            HStack(alignment: .top, spacing: 10) {
                if self.isCompleteButton {
                    Image(systemName: self.checkState ? "checkmark.square" : "square")
                } else {
                    if let index = self.selectedExercises.firstIndex(of: self.exerciseName) {
                        Image(systemName: "\(index + 1).circle")
                    } else {
                        Image(systemName: "circle")
                    }
                }
                Text(exerciseName.rawValue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .foregroundColor(Color.white)
        .onAppear {
            if self.isCompleteButton {
                self.checkState = self.selectedExercises.count == self.allExercises.count
            } else {
                self.checkState = self.selectedExercises.contains(self.exerciseName)
            }
        }
    }
}


