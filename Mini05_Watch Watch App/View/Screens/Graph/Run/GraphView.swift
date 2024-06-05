//
//  GraphView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 24/05/24.
//

import SwiftUI

struct GraphView: View {
    @State private var enums: [RunEnum] = [.avgHeartRate, .avgSpeed, .totalDistance, .totalEnergy, .totalTime]

    var body: some View {
        TabView {
            ForEach(enums) { exercise in
                GraphExerciseView(runEnum: exercise)
            }
        }
        .tabViewStyle(.carousel)
    }
}

#Preview {
    GraphView()
}
