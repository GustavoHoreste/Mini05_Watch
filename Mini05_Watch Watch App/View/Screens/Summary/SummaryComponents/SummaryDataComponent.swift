//
//  SummaryDataComponent.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI

struct SummaryDataComponent: View {
    let title: String
    let value: String

    var body: some View {
        ZStack {
            Text(value)
                .myCustonFont(fontName: .sairaMedium, size: 20, valueScaleFactor: 0.8)
                .padding(.bottom)
            VStack {
                Spacer()
                Text(title)
                    .myCustonFont(fontName: .sairaRegular, size: 9, valueScaleFactor: 0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
        }
        .frame(width: 95, height: 68)
        .background(Color(.nextButton))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SummaryDataComponent(title: "Tempo de corrida", value: "20:05")
}

