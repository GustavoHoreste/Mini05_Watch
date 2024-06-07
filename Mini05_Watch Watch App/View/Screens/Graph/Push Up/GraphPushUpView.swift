//
//  GraphPushUpView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import SwiftUI

struct GraphPushUpView: View {
    @State private var enums: [PushUpEnum] = [.repetitions, .avgHeartRate, .totalEnergy]

    var body: some View {
        TabView {
            ForEach(enums) { exercise in
                GraphExercisePushUpView(pushUpEnum: exercise)
            }
        }
        .background(.bg)
        .tabViewStyle(.carousel)
    }
}

#Preview {
    GraphPushUpView()
}
