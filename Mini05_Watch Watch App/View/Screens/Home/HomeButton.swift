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
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                    .rotation(.degrees(45))
                    .frame(width: 100,height: 100)
                    .foregroundStyle(.cyan)
                Text(name)
                    .foregroundStyle(.black)
                    .padding(15)
                
                
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    HomeButton(name: "Avaliação", destination: ContentView())
    
}

