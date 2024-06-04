//
//  ModifierFonts.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 04/06/24.
//

import Foundation
import SwiftUI


struct MyCustonFont: ViewModifier{
    var fontName: Fonts
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName.rawValue, size: size))
    }
}

extension View{
    func myCustonFont(fontName: Fonts, size: CGFloat) -> some View{
        self.modifier(MyCustonFont(fontName: fontName, size: size))
    }
}
