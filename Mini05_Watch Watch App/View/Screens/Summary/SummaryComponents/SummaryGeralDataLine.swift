//
//  SummaryGeralDataLine.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import SwiftUI

struct SummaryGeralDataLine: View {
    
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .myCustonFont(fontName: .sairaMedium, size: 15, valueScaleFactor: 0.8)
            Spacer()
            Text(value)
                .myCustonFont(fontName: .sairaRegular, size: 15, valueScaleFactor: 0.8)
        }
    }
}

#Preview {
    SummaryGeralDataLine(title: "Total", value: "40:05")
}
