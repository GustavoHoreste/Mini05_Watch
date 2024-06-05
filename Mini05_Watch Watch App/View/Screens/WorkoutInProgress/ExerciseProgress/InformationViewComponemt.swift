//
//  InformationViewComponemt.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 03/06/24.
//

import SwiftUI

struct InformationViewComponemt: View {
    let nameExercise: String
    let value: Double
    
    var body: some View {
        VStack(spacing: -10){
            Text(nameExercise)
                .myCustonFont(fontName: .sairaRegular, size: 23.5, valueScaleFactor: 0.8)
            
//            VStack(spacing: -10){
                Text("Velocidade atual")
                .myCustonFont(fontName: .sairaRegular, size: 18, valueScaleFactor: 0.8)
    //                .padding(.top)
                
                Text("\(value, specifier: "%.0f")Km/h")
                .myCustonFont(fontName: .sairaBlack, size: 60, valueScaleFactor: 0.8)
                    .foregroundStyle(Color(.myOrange))
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal)
//            }
            HeartAndCaloriesViewComponemt()
        }
    }
}



    
