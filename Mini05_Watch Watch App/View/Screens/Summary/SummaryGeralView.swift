//
//  SummaryGeralView.swift
//  Mini05_Watch Watch App
//
//  Created by André Felipe Chinen on 05/06/24.
//

import SwiftUI

struct SummaryGeralView: View {
    var body: some View {
        NavigationStack{
            NavigationLink("Voltar Home") {
                HomeView()
            }.navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SummaryGeralView()
}
