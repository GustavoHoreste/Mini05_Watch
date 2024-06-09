//
//  GraphExerciseAbdominalView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 04/06/24.
//

import SwiftUI
import SwiftData
import Charts

struct GraphExerciseAbdominalView: View {
    @Environment(\.modelContext) var modelContext
    @State var viewModel: GraphExerciseAbdominalViewModel
    
    init(abdominalEnum: AbdominalEnum) {
        viewModel =  GraphExerciseAbdominalViewModel(abdominalEnum: abdominalEnum)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: viewModel.abdominalEnum.sfSymbol)
                            .foregroundStyle(viewModel.abdominalEnum.color)
                        Text("\(viewModel.getAverage(), specifier: "%.0f")\(viewModel.complementValue())")
                            .font(.system(size: 26))
                    }
                    .padding(.trailing)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                            Chart(viewModel.graphData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value(viewModel.abdominalEnum.id, data[keyPath: viewModel.abdominalEnum.keyPath])
                                )
                                .foregroundStyle(viewModel.abdominalEnum.color)
                                .lineStyle(.init(lineWidth: 3))
                                .symbol {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 10)
                                }
                                
                                PointMark(
                                    x: .value("Date", data.date),
                                    y: .value(viewModel.abdominalEnum.id, data[keyPath: viewModel.abdominalEnum.keyPath])
                                )
                                .opacity(0)
                                .annotation(position: .top) {
                                    Text("\(data[keyPath: viewModel.abdominalEnum.keyPath], specifier: "%.0f")")
                                        .font(.system(size: 11))
                                        .foregroundColor(.white)
                                }
                            }
                            .chartYScale(domain: viewModel.minYValue()...viewModel.maxYValue())
                            .chartXScale(domain: viewModel.minXDate()...viewModel.maxXDate())
                            .chartYAxis() {
                                AxisMarks(position: .trailing)
                            }
                            .chartXAxis {
                                AxisMarks(preset: .aligned, values: viewModel.graphData.map { $0.date }) { value in
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
                            .frame(width: geo.size.width + (15 * CGFloat(viewModel.graphData.count)))
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
        .navigationTitle(viewModel.abdominalEnum.id)
    }
}

#Preview {
    GraphExerciseAbdominalView(abdominalEnum: .repetitions)
}
