//
//  GraphAbdominalView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import SwiftUI

struct GraphAbdominalView: View {
    @State private var enums: [AbdominalEnum] = [.repetitions, .avgHeartRate, .totalEnergy]

    var body: some View {
        TabView {
            ForEach(enums) { exercise in
                GraphExerciseAbdominalView(abdominalEnum: exercise)
            }
        }
        .background(.bg)
        .tabViewStyle(.carousel)
    }
}

#Preview {
    GraphAbdominalView()
}
