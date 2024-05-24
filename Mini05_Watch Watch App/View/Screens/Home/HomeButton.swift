//
//  HomeButton.swift
//  Mini05 Watch App
//
//  Created by Samu Lima on 21/05/24.
//

import SwiftUI

struct HomeButton<Destination: View>: View {
    let name: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination){
            HStack {
                Spacer()
                Text(name)
                    .padding(15)
                Spacer()
            }
        }
    }
}


#Preview {
    HomeButton(name: "Avaliação", destination: ContentView())
}

