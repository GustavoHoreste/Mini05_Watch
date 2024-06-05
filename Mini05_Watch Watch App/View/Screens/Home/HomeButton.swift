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
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .rotation(.degrees(45))
                    .frame(width: 70,height: 70)
                    .foregroundStyle(Color("myOrange"))
                Text(name)
                    .foregroundStyle(.white)
                    .myCustonFont(fontName: .sairaMedium, size: 14, valueScaleFactor: 0)
                
                
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    HomeButton(name: "Avaliação", destination: ContentView())
    
}

