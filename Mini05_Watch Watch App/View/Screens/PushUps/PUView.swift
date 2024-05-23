//
//  PUView.swift
//  Mini05 Watch App
//
//  Created by Felipe Porto on 21/05/24.
//

import SwiftUI

struct PUView: View {
    @StateObject var viewModel: PUViewModel
    
    var body: some View {
        ScrollView {
                
                // Flexão
                Text("Flexão")
                    .font(.title)
                    .padding(.bottom)
                
                Divider()
                
                // Timer
                Text(viewModel.elapsedTimeString(from: viewModel.elapsedTime))
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
               
                
                // Outros itens
                VStack {
                    HStack {
                        Text("Calorias queimadas")
                        Spacer()
                    }
                    HStack {
                        Text("\(viewModel.caloriesBurned, specifier: "%.2f") cal")
                            .font(.title2)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                // Frequência Cardíaca
                VStack {
                    HStack {
                        Text("Frequência Cardíaca")
                        Spacer()
                    }
                    HStack {
                        Text("\(viewModel.heartRate, specifier: "%.0f") bpm")
                            .font(.title2)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                // Número de repetições
                VStack {
                    HStack {
                        Text("Num. de repetições")
                        Spacer()
                    }
                    HStack {
                        Text("\(viewModel.pushUps)")
                            .font(.title2)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                // Botão de Iniciar/Terminar
                HStack {
                    Button(action: {
                        if viewModel.finalDate != nil || viewModel.initialDate == nil {
                            viewModel.startActivity()
                        } else {
                            viewModel.endActivity()
                        }
                    }) {
                        Text(viewModel.finalDate != nil || viewModel.initialDate == nil ? "Iniciar" : "Terminar")
                    }
                }
                .padding()
            }
    }
}


#Preview {
    let model = PUModel(pushUps: 10)
    let viewModel = PUViewModel(model: model)
    return PUView(viewModel: viewModel)
}
