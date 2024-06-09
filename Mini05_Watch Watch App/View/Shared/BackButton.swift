//
//  BackButton.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 04/06/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button{ self.dismiss() }label: {
            HStack{
                Image(.backForVoltar)
                Text("Voltar")
            }
        }
        .font(.system(size: 14, weight: .medium))
        .padding()
        .background(Color(.nextButton))
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    BackButton()
}
