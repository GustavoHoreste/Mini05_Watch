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
    
    @Environment(\.modelContext) var modelContext
    @State var viewModel: GraphExerciseViewModel
    
//    @Query(sort: \RunData.date) var runData: [RunData]
    
    init(runEnum: RunEnum) {
        viewModel =  GraphExerciseViewModel(runEnum: runEnum)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundStyle(viewModel.runEnum.color)
                        Text("\(viewModel.getAverage(), specifier: "%.0f")")
                            .font(.system(size: 26))
                    }
                    .padding(.trailing)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            Chart(viewModel.graphData) { data in // Mudar para runData aqui
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value(viewModel.runEnum.id, data[keyPath: viewModel.runEnum.keyPath])
                                )
                                .foregroundStyle(viewModel.runEnum.color)
                                .lineStyle(.init(lineWidth: 3))
                                .symbol {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 10)
                                }
                                
                                PointMark(
                                    x: .value("Date", data.date),
                                    y: .value(viewModel.runEnum.id, data[keyPath: viewModel.runEnum.keyPath])
                                )
                                .opacity(0)
                                .annotation(position: .top) {
                                    Text("\(data[keyPath: viewModel.runEnum.keyPath], specifier: "%.0f")")
                                        .font(.system(size: 11))
                                        .foregroundColor(.white)
                                }
                            }
                            .chartYScale(domain: viewModel.minYValue()...viewModel.maxYValue()) // Mudar para runData aqui
                            .chartXScale(domain: viewModel.minXDate()...viewModel.maxXDate()) // Mudar para runData aqui
                            .chartYAxis() {
                                AxisMarks(position: .trailing)
                            }
                            .chartXAxis {
                                AxisMarks(preset: .aligned, values: viewModel.graphData.map { $0.date }) { value in // Mudar para runData aqui
                                    AxisGridLine()
                                    AxisValueLabel {
                                        if let date = value.as(Date.self) {
                                            VStack {
                                                Text(date, format: .dateTime.day())
                                                Text(date, format: .dateTime.month(.abbreviated))
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width + (15 * CGFloat(viewModel.graphData.count))) // Mudar para runData aqui
                            .id("chartEnd")
                            .padding()
                        }
                        .onAppear {
                            proxy.scrollTo("chartEnd", anchor: .trailing)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchData()
            viewModel.separateByDay()
        }
        .navigationTitle(viewModel.runEnum.id)
    }
}

#Preview("grafico") {
    GraphExerciseView(runEnum: .avgHeartRate)
}
