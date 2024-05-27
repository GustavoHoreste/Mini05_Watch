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
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        let _ = print(elapsedTime)
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds, { oldValue, newValue in
                timeFormatter.showSubseconds = oldValue
            })
    }
}

#Preview {
    ElapsedTimeView(elapsedTime: 0)
}
