//
//  ButtonNext.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 01/06/24.
//

import SwiftUI

struct ButtonNext<Content: View>: View{
    let destination: Content
    
    var body: some View {
        NavigationLink(destination: destination) {
            ButtonNextLabel()
        }
        .buttonStyle(PlainButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct ButtonNextLabel: View {
    var body: some View {
            HStack{
                Text("Próximo")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 14, weight: .medium))
            .padding()
            .background(Color(.nextButton))
            .buttonStyle(PlainButtonStyle())
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    ButtonNext(destination: EmptyView())
}
