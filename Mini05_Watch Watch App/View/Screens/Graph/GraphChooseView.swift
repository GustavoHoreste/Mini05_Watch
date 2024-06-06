//
//  GraphChooseView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import SwiftUI

struct GraphChooseView: View {
    var body: some View {
        NavigationStack{
            List{
                HomeButton(name: "Corrida", destination: GraphView())
                    .padding(20)
                HomeButton(name: "Flexao", destination: GraphPushUpView())
                    .padding(20)
                HomeButton(name: "Abdominal", destination: GraphAbdominalView())
                    .padding(20)
            }
            .listStyle(.carousel)
        }
        .navigationTitle("Gráficos")
    }
}

#Preview {
    GraphChooseView()
}
