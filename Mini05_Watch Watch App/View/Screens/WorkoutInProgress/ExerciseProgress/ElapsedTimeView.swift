//
//  ElapsedTimeView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 27/05/24.
//

import SwiftUI
import WatchKit

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval
    var showSubseconds: Bool = true
    var size: Double
    var font: Fonts
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .myCustonFont(fontName: font, size: size, valueScaleFactor: 0.8)
            .onChange(of: showSubseconds) { oldValue, newValue in
                timeFormatter.showSubseconds = oldValue
            }
            .frame(width: 150, height: 40, alignment: .center)
    }
}

#Preview {
    ElapsedTimeView(elapsedTime: 0, size: 60, font: .sairaBlack)
}
