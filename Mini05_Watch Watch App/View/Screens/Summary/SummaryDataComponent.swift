//
//  SummaryDataComponent.swift
//  Mini05 Watch App
//
//  Created by André Felipe Chinen on 22/05/24.
//

import SwiftUI

struct SummaryDataComponent: View {
    let title: String
    let extensionName: String
    let value: Double

    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(String(describing: formattedValue()))
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}

extension SummaryDataComponent{
    private func formattedValue() -> String {
        return String(format: "%.2f", value)
    }
}

#Preview {
    SummaryDataComponent(title: "Total Time", extensionName: "cal", value: 00)
}

