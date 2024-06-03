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
        VStack{
            Text(nameExercise)
                .font(.system(size: 30))
            
            Text("Velocidade atual")
                .font(.system(size: 20))
            
            Text("\(value, specifier: "%.0f")Km/h")
                .font(.system(size: 50))
            
            HeartAndCaloriesViewComponemt()
        }
    }
}

#Preview {
    InformationViewComponemt(nameExercise: "Corrida", value: 1234)
}

    
