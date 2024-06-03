//
//  SelectButtonComponent.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 01/06/24.
//

import SwiftUI

struct SelectBoxConponent: View {
    @Binding var isSelect: Bool 
    let nameButtom: String
    let action: () -> Void
    
    var body: some View {
        HStack{
            Label(nameButtom, systemImage: isSelect ? "smallcircle.filled.circle" : "circle")
                .font(.system(size: 20, weight: .regular))
                .lineLimit(2)
        
        }.onTapGesture {
            self.isSelect.toggle()
            self.action()
        }
    }
}


