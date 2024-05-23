//
//  SummaryView.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                SummaryDataComponent(title: "Total Time",
                                  value: "00:00:00")
                    .foregroundStyle(.yellow)
                SummaryDataComponent(title: "Total Distance",
                                  value: "21,41 m")
                    .foregroundStyle(.green)
                SummaryDataComponent(title: "Total Energy",
                                  value: "1 Cal")
                    .foregroundStyle(.pink)
                SummaryDataComponent(title: "Avg. Heart Rate",
                                  value: "121 bpm")
                    .foregroundStyle(.red)
                SummaryDataComponent(title: "Avg. Speed",
                                  value: "4,1 M/s")
                    .foregroundStyle(.orange)
                Button("Done") {
                    
                }
            }
            .scenePadding()
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SummaryView()
}

