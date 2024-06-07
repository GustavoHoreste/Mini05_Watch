//
//  SummaryGeralData.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import SwiftUI

struct SummaryGeralData: View {
    
    var title: String
    var subTitle: [String]
    var subValue: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .myCustonFont(fontName: .sairaBold, size: 18, valueScaleFactor: 0.8)
                    .foregroundStyle(.myOrange)
                Spacer()
            }
            ForEach(Array(zip(subTitle, subValue)), id: \.0) { title, value in
                SummaryGeralDataLine(title: title, value: value)
            }
            Divider()
        }
    }
}

#Preview {
    SummaryGeralData(title: "Tempo", subTitle: ["Total", "Corrida"], subValue: [" 40:05", "20:05"])
}
