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
            Image(systemName: isSelect ? "smallcircle.filled.circle" : "circle")
            Text(nameButtom)
                .lineLimit(2)
                .font(.system(size: 12))
        }.onTapGesture {
            self.isSelect.toggle()
            self.action()
        }
    }
}




