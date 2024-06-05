//
//  StatisticTimeComponent.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 02/06/24.
//

import SwiftUI

struct RecordTimeComponent: View {
    @Binding var value: Double
    let name: String
    
    var body: some View {
        VStack{
            Text(String(describing: value))
                .font(.system(size: 18, weight: .medium))
            
            Text(name)
                .font(.system(size: 12, weight: .medium))
        }
    }
}
