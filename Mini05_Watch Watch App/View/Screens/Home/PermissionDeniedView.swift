//
//  PermissionDeniedView.swift
//  Mini05_Watch Watch App
//
//  Created by Gustavo Horestee Santos Barros on 26/05/24.
//

import SwiftUI

struct PermissionDeniedView: View {
    var body: some View {
        VStack{
           Text("Permissão Negada")
                .myCustonFont(fontName: .sairaBold, size: 20, valueScaleFactor: 0.8)
                .foregroundStyle(.myOrange)
            
           Text("Abra o aplicativo Watch no seu iPhone, vá para Saúde > Apps, e permita o acesso ao HealthKit para este aplicativo.")
                .myCustonFont(fontName: .sairaRegular, size: 15, valueScaleFactor: 0.8)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg)
    }
}

#Preview {
    PermissionDeniedView()
}
