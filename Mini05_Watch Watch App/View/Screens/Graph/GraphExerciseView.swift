//
//  GraphExerciseView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 24/05/24.
//

import SwiftUI
import SwiftData
import Charts

struct GraphExerciseView: View {
    
    @Query(sort: \RunData.date) var runData: [RunData]
    
    var runEnum: RunEnum
    
    var body: some View {
        NavigationStack {
            Chart(runData) { data in
                switch runEnum {
                case .totalTime:
                    LineMark(x: .value("Date", data.date), y: .value("Total Time", data.totalTime))
                        .foregroundStyle(.green)
                        .symbol(.circle)
                case .totalDistance:
                    LineMark(x: .value("Date", data.date), y: .value("Total Distance", data.totalDistance))
                        .foregroundStyle(.blue)
                        .symbol(.circle)
                case .totalEnergy:
                    LineMark(x: .value("Date", data.date), y: .value("Total Energy", data.totalEnergy))
                        .foregroundStyle(.orange)
                        .symbol(.circle)
                case .avgHeartRate:
                    LineMark(x: .value("Date", data.date), y: .value("Avg Heart Rate", data.avgHeartRate))
                        .foregroundStyle(.red)
                        .symbol(.circle)
                case .avgSpeed:
                    LineMark(x: .value("Date", data.date), y: .value("Avg Speed", data.avgSpeed))
                        .foregroundStyle(.yellow)
                        .symbol(.circle)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding()
        }
        .navigationTitle(runEnum.id)
    }
}

