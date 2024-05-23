//
//  HomeView.swift
//  Mini05 Watch App
//
//  Created by Gustavo Horestee Santos Barros on 20/05/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            List{
                HomeButton(name: "Avaliação", destination: SelectEvaluationView())
                    .padding(20)
                HomeButton(name: "Flexao", destination: PUView(viewModel: PUViewModel(model: PUModel())))
                    .padding(20)
                HomeButton(name: "Gráficos", destination: EmptyView())
                    .padding(20)
            }
            .listStyle(.carousel)
        }
        
    }
}

#Preview {
    HomeView()
}

