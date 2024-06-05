//
//  GraphPushUpView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import SwiftUI

struct GraphPushUpView: View {
    @State private var enums: [PushUpEnum] = [.repetitions, .avgHeartRate, .totalEnergy, .totalTime]

    var body: some View {
        TabView {
            ForEach(enums) { exercise in
                GraphExercisePushUpView(pushUpEnum: exercise)
            }
        }
        .tabViewStyle(.carousel)
    }
}

#Preview {
    GraphPushUpView()
}
