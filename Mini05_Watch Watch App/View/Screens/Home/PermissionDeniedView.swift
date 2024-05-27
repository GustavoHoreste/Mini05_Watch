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
           Text("Permissao negada")
           Text("Abra o aplicativo Watch no seu iPhone, vá para Saúde > Apps, e permita o acesso ao HealthKit para este aplicativo.")
                .padding()
        }
    }
}

#Preview {
    PermissionDeniedView()
}
