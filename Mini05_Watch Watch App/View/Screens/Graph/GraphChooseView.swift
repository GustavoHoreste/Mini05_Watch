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
            ScrollView {
                VStack{
                    HomeButton(name: "Corrida", destination: GraphView())
                        .padding(20)
                    HomeButton(name: "Flexao", destination: GraphPushUpView())
                        .padding(20)
                    HomeButton(name: "Abdominal", destination: GraphAbdominalView())
                        .padding(20)
                }
            }
            .background(.bg)
//            .listStyle(.carousel)
        }
        .navigationTitle("Gráficos")
    }
}

#Preview {
    NavigationStack {
        GraphChooseView()
    }
}
